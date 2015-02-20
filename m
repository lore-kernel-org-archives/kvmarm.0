From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: maybe a virtio-balloon-device issue ?
Date: Thu, 19 Feb 2015 18:46:01 -0800
Message-ID: <54E69FE9.4070200@samsung.com>
References: <54D41681.7080401@samsung.com> <54D4E459.9040007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <54D4E459.9040007@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, denz@openvz.org, rusty@rustycorp.com.au, rmapsudova@parallels.com
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu


I've been testing the patch few days, the bolloon OOM notifier patch
seems to
do a good jobs freeing memory before OOM killer is about to kill a process.
Although on few ocassions it wasn't enough.

But if you're memory target is anywhere within some range of freeram, and
it's hard to say how much but 3 to 6% or less, guest locks up, with stack
backtraces from vballoon thread, or other processes and page reclaim code
prints messages. Also I get bad page state errors. Admin looses access
to guest.

I tried to use the 'admin_reserve_kbytes' approach, create a buffer
range  - and
sanity check the target value. I have not seen any issues with loads I'm
running but it's still may be susceptible to a rapid free memory drop while
balloon is inflating. Of course making the gap larger (min_reserve) makes it
less susceptible or removes it altogether. I included sample patch.

Would appreciate suggestions, on how to make inflate a safe operation, so in
the worst case aggressive page reclaim, or OOM killer kick in.
I tested on ARM & x86.

- Mario

--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -284,12 +284,22 @@ static void virtballoon_changed(struct
virtio_device *vdev)
 static inline s64 towards_target(struct virtio_balloon *vb)
 {
        __le32 v;
-       s64 target;
+       s64 diff;
+       unsigned long min_reserve;
+       struct sysinfo si;

        virtio_cread(vb->vdev, struct virtio_balloon_config, num_pages, &v);

-       target = le32_to_cpu(v);
-       return target - vb->num_pages;
+       diff = (s64) le32_to_cpu(v) - vb->num_pages;
+       si_meminfo(&si);
+
+       min_reserve = min((unsigned long) (si.freeram - (3 *
si.freeram/100)),
+               (unsigned long) (0x800000 >> PAGE_SHIFT));
+
+       if(diff == 0 || diff >= (si.freeram - min_reserve))
+               return 0;
+
+       return diff;
 }




On 02/06/2015 07:57 AM, Paolo Bonzini wrote:
> 
> 
> On 06/02/2015 02:18, Mario Smarduch wrote:
>> Hi,
>>
>> I'm looking into qemu/balloon driver VM overcommit. I noticed
>> virtio-balloon driver will take any setting from virtio-balloon-device
>> to the point Guest dies.
>>
>> For a 1G guest
>> $ sudo echo balloon 100 | socat - tcp4-connect:127.0.0.1:4444
>>
>> you get (same with libvirt setmem)
>>
>> root@localhost:~# free
>> -bash: fork: Cannot allocate memory
>> root@localhost:~# ps
>> -bash: fork: Cannot allocate memory
>>
>> $ sudo info balloon | socat ... - confirms setting
>>
>> The balloon driver has been there for a while, not sure what I'm missing?
>>
>> virtio-balloon-device provide free memory, i.e., - externally accessible
>> to host.  But this appears more like a hint for an inflate request, snmp
>> mibs
>> provide more detailed resource info then that.
>>
>> I'm wondering if the driver should  not have some heuristic
>> check for an inflate request so it doesn't over inflate?  Similar to
>> kernel overcommit.
> 
> See this patch:
> 
> commit 5a10b7dbf904bfe01bb9fcc6298f7df09eed77d5
> Author: Raushaniya Maksudova <rmaksudova@parallels.com>
> Date:   Mon Nov 10 09:36:29 2014 +1030
> 
>     virtio_balloon: free some memory from balloon on OOM
> 
> Looks like the QEMU part was never posted though.
> 
> Paolo
> 

