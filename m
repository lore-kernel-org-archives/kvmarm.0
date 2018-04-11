From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] vhost: Fix vhost_copy_to_user()
Date: Wed, 11 Apr 2018 15:45:59 +0200
Message-ID: <355234b2-651e-4e85-b5d2-d92bb6e33f13@redhat.com>
References: <1523453438-4266-1-git-send-email-eric.auger@redhat.com>
 <85c033b9-b230-7ef9-744c-4e2799684609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <85c033b9-b230-7ef9-744c-4e2799684609@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Wang <jasowang@redhat.com>, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, kvmarm@lists.cs.columbia.edu
Cc: stefanha@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jason,

On 11/04/18 15:44, Jason Wang wrote:
> 
> 
> On 2018年04月11日 21:30, Eric Auger wrote:
>> vhost_copy_to_user is used to copy vring used elements to userspace.
>> We should use VHOST_ADDR_USED instead of VHOST_ADDR_DESC.
>>
>> Fixes: f88949138058 ("vhost: introduce O(1) vq metadata cache")
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> This fixes a stall observed when running an aarch64 guest with
>> virtual smmu
>> ---
>>   drivers/vhost/vhost.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index bec722e..f44aead 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -744,7 +744,7 @@ static int vhost_copy_to_user(struct
>> vhost_virtqueue *vq, void __user *to,
>>           struct iov_iter t;
>>           void __user *uaddr = vhost_vq_meta_fetch(vq,
>>                        (u64)(uintptr_t)to, size,
>> -                     VHOST_ADDR_DESC);
>> +                     VHOST_ADDR_USED);
>>             if (uaddr)
>>               return __copy_to_user(uaddr, from, size);
> 
> Acked-by: Jason Wang <jasowang@redhat.com>
> 
> Thanks!
> 
> Stable material I think.

yes I think so.

Thanks

Eric
