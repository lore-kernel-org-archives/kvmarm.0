Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFEF25B091
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 23:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783121792; cv=none; b=t8TjKUaTcmlKuAe2do9cEihfh9cInkdv9iSHEh8UeJOvXO+XyuzBNfcgo8WkIQI18GonW4M7cH0GMx72KmJTprO/8oUyKtmmHt+rrlcAjgXiYeC2Ai/dXXM48OEPzrpwMTQ5xsQVhyvPTlHried2gIH5Kdb7hqszpobtC1XpfVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783121792; c=relaxed/simple;
	bh=FJrkXEGnSM16j0KzsIIDtaYYae/POg0kQ+D0kVLkfcU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=htt9VgXVHta3uCL5A0fNZJnPVI6x4h6Mj3QYSed0PY9rV1tKvloPLRMhgECZrVhhC5qdrv+ibGwoQU6S0LGbufW7LU//Om7/NlfZiozMgTBKsp5wZYVrWLSkkHlHA9VGjDCNs72S32dwYbYUfIrJ3nnawzbN4DZNkvpWuLWgKfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cWBypMv1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cWBypMv1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783121789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SwERFhdzSv4+amzd0QIu7iqPOMHAE60bTr8DX2KgDYo=;
	b=cWBypMv1k/+P6CbhAqILOAUgz2o9NkV41uHVHlxdDkSwGE2IEoZ54QoIbt92LzP5b7QOkU
	RnR9lohaSaFPpjA2iEjcpkGA79cr7dGjZ6i2Ie9VuwOL9nbcbKrr3fej1YTETWodbQ6bRv
	xKMrqmq7dBV+UpfZ8T4lgAsdAH3n8hw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-9b5VcDuXNfKzIBm7IXQfaA-1; Fri, 03 Jul 2026 19:36:28 -0400
X-MC-Unique: 9b5VcDuXNfKzIBm7IXQfaA-1
X-Mimecast-MFC-AGG-ID: 9b5VcDuXNfKzIBm7IXQfaA_1783121787
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3810960140eso1631790a91.2
        for <kvmarm@lists.linux.dev>; Fri, 03 Jul 2026 16:36:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783121787; x=1783726587;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SwERFhdzSv4+amzd0QIu7iqPOMHAE60bTr8DX2KgDYo=;
        b=g56SL2Z3UmDynSi07ccgsVxVVhp3V2Zr2fS/XU/RDHek6nUAVMASX8sKXFDfU5KKZz
         bfKkwclznswt71HNeIS6Y0ssHiph3wZWioDll7rdxJoEvnPKgzkmKSFgvNXjnOh3l7w+
         mXXENQa6Mrk4usq0IJiGCaVr7IIIIUF/aXoJW2Wsdol9Z/q0zNPdxZtCk2efW4xTB8yK
         WpnBTPypIc2M9J8xZocmjAGd1obFMuq/0+O+XNx7CSfHAbtLYeYklse6dhAPBScd1t5n
         1+MMqRhjMBw8gYQP0RGqrVJ/H+1kLK1O3ONDaVl755dO7hJu/dasSdkw9y7Qn+1Dfjn8
         ntxw==
X-Forwarded-Encrypted: i=1; AHgh+Rqdr6+XrO4ZZctvr+SOe1dFl4ugmr+Q0jS23N6/0YkMAgpZT4wgJPJd7vUJm+uleiISfVIbvHo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxA0UhlcGoQbPAmnieGVBTqOhPbfTNkoaFCo/8zPcaX5G5AiSrv
	BX1TRzl+yfszy6YRFS5XoUrJtl4qlLWXum0850i8q9CLbh+rg1eQsI77U5GRK9WZYP5GxyQQE5s
	GmWyMDcfiLUOfnult3thYU9zTqklU38qJi06V4TGm/DJqmYlO5WKj2W3vQQ==
X-Gm-Gg: AfdE7ckAKYShXqvkFx2Xpgx0o7bLW8H5UTMEYGjapkaMgnbFQvb4Q8RkaHv2E95Ujp+
	ZPgW1e8Qvr62JhyuOqvAGJTbpCwLaae63NaYF/Bpj1j4m8cYlXaoKl1a1QdVGLMhDQwBNn0cZ+j
	hYLIyowG0HVl3Vo6L9MXD4X7PEUkZQgdizDwEke7JE5gQ588csloPHiXWeWHMFFp+9Cmzd7s8AA
	czTuV8surxkR5Oya26jpjKdIvYt3DwKNEHqskzJ2PNG1u7hBtkKkqQG+optNhXK8nPxaKvKgc6V
	xmP2J4JiAwJgWkq5Lt+ADJtUiydV/MD+DNjxYdLu747HNhoA3n5ZMmppgJCYFbfvp7sQuqiGSoG
	pSXEaeyv1XyJAjkYp17cvRTeXXNyPAn9eTKlNmxMrPwIx1nSICJt6sg==
X-Received: by 2002:a17:90a:e708:b0:37e:a09:2640 with SMTP id 98e67ed59e1d1-382807ae330mr1215688a91.7.1783121786870;
        Fri, 03 Jul 2026 16:36:26 -0700 (PDT)
X-Received: by 2002:a17:90a:e708:b0:37e:a09:2640 with SMTP id 98e67ed59e1d1-382807ae330mr1215656a91.7.1783121786156;
        Fri, 03 Jul 2026 16:36:26 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bbd223esm25620535eec.21.2026.07.03.16.36.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 16:36:25 -0700 (PDT)
Message-ID: <77d7e748-25d0-4090-8954-ab96bb37f223@redhat.com>
Date: Sat, 4 Jul 2026 09:36:13 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 29/44] arm64: RMI: Runtime faulting of memory
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <aiJ6u83O0nVUtPyv@lpieralisi>
 <ecef952b-e8c6-4102-933b-c99c46f14431@redhat.com>
 <aiLes2ecZSr17UwZ@lpieralisi>
 <1e39094f-7fa3-4ef1-be54-53d7a8643506@redhat.com>
 <98d2a0f3-b831-466a-8212-5bcf97ad9d8b@arm.com>
 <8da87878-2a5d-478a-a280-60dbed7ad1b9@redhat.com>
 <9482dfbc-4d96-47ba-a615-f4ba0bda833f@arm.com>
 <8f81ed99-c53a-4196-baa2-adea9239a000@redhat.com>
 <aj6sdzlbxT8D5fnf@lpieralisi>
 <901398bb-ed6c-4997-b3cd-ce2829b09c87@redhat.com>
 <akUc/ScJN0GlM+9G@lpieralisi>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <akUc/ScJN0GlM+9G@lpieralisi>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RfJ4Uk5gX_Z95V8oSsO7HW19bu5h_kfGvDbh_3aFgro_1783121787
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/1/26 11:58 PM, Lorenzo Pieralisi wrote:
> On Sun, Jun 28, 2026 at 08:33:01PM +1000, Gavin Shan wrote:
>> On 6/27/26 2:44 AM, Lorenzo Pieralisi wrote:
>>> On Fri, Jun 26, 2026 at 09:43:03PM +1000, Gavin Shan wrote:
>>>> On 6/26/26 6:47 PM, Suzuki K Poulose wrote:
>>>>> On 26/06/2026 08:43, Gavin Shan wrote:
>>>>>> On 6/26/26 1:58 AM, Suzuki K Poulose wrote:
>>>>>>> On 25/06/2026 14:53, Gavin Shan wrote:
>>>>>>>> On 6/6/26 12:35 AM, Lorenzo Pieralisi wrote:
>>>>>>>>> On Fri, Jun 05, 2026 at 06:11:11PM +1000, Gavin Shan wrote:
>>>>>>>>>> On 6/5/26 5:28 PM, Lorenzo Pieralisi wrote:
>>>>>>>>>>> On Fri, Jun 05, 2026 at 04:23:15PM +1000, Gavin Shan wrote:
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>>>>>
>>>>>>>>>> I tried to rebase Jean's latest QEMU series [1] to upstream QEMU, and found
>>>>>>>>>> that memory slots backed by THP are broken. With THP disabled on the host and
>>>>>>>>>> other fixes (mentioned in my prevous replies) applied on the top of this (v14)
>>>>>>>>>> series, I'm able to boot a realm guest with rebased QEMU series [2], plus more
>>>>>>>>>> fxies on the top.
>>>>>>>>>>
>>>>>>>>>> [1] https://git.codelinaro.org/linaro/dcap/qemu.git  (branch: cca/ latest)
>>>>>>>>>> [2] https://git.qemu.org/git/qemu.git                (branch: cca/ gavin)
>>>>>>>>>>
>>>>>>>>>> Lorenzo, You may be saying there is someone making QEMU to support ARM/CCA?
>>>>>>>>>
>>>>>>>>> Mathieu and I are working on that yes and with Steven/Suzuki to fix the THP
>>>>>>>>> issues you pointed out above.
>>>>>>>>>
>>>>>>>>>> If so, I'm not sure if there is a QEMU repository for me to try?
>>>>>>>>>
>>>>>>>>> We should be able to submit patches by end of June - we shall let you know
>>>>>>>>> whether we can make something available earlier.
>>>>>>>>>
>>>>>>>>
>>>>>>>> Not sure if there are other known issues in this series. It seems the stage2
>>>>>>>> page fault handling on the shared space isn't working well. In my test, the
>>>>>>>> vring (struct vring_desc) of virtio-net-pci is updated by the guest, and the
>>>>>>>> data isn't seen by QEMU, I'm suspecting if the host-page-frame-number is properly
>>>>>>>> resolved in the s2 page fault handler for shared (unprotected) space.
>>>>>>>>
>>>>>>>> - I rebased Jean's latest qemu branch to the upstream qemu;
>>>>>>>>
>>>>>>>> - On the host, which is emulated by qemu/tcg, the THP (transparent huge page) is
>>>>>>>>      disabled.
>>>>>>>>
>>>>>>>> - On the guest, I can see the virtio vring (struct vring_desc) is updated. The
>>>>>>>>      S1 page-table entry looks correct because the corresponding physical address
>>>>>>>>      0x10046880000 is a sane shared (unprotected) space address.
>>>>>>>>
>>>>>>>>      [   52.094143] software IO TLB: Memory encryption is active and system is using DMA bounce buffers
>>>>>>>>      [   52.289746] virtqueue_add_desc_split: desc[0]@0xffff000006880000, [00000100b983f000  00000640  0002  0001]
>>>>>>>>      [   52.432150] PTE 0x00e8010046880707 at address 0xffff000006880000
>>>>>>>>
>>>>>>>> - On the host, the s2 page-table-entry is unmapped due to attribute transition (private -> shared).
>>>>>>>>      A subsequent S2 page fault is raised against the adress and the s2 page-table-entry is built.
>>>>>>>>
>>>>>>>>      [  109.259077] ====> realm_unmap_shared_range: tracked_unprot_addr=0x10046880000
>>>>>>>>      [  109.260249] realm_unmap_shared_range: unmapped shared range at 0x10046880000
>>>>>>>>      [  109.317786] realm_unmap_shared_range: unmapped shared range at 0x10046880000
>>>>>>>>      [  109.629939] ====> kvm_handle_guest_abort: fault_ipa=0x10046880000, esr=0x92000007
>>>>>>>>      [  109.630245] realm_map_non_secure: ipa=0x10046880000, pfn=0xb8b59, size=0x1000, prot=0xf
>>>>>>>>      [  109.630331] realm_map_non_secure: ipa=0x10046880000, ipa_top=0x10046881000, flags=0x1e0001, range_desc=0xb8b59004
>>>>>>>
>>>>>>> Are you able to correlate the order of the transitions and the Guest
>>>>>>> access with RMM log ? We haven't seen this from our end. We are aware
>>>>>>> of permission fault issues with Unprotected IPA when backing the memslot
>>>>>>> with MAP_PRIVATE areas. But this looks different.
>>>>>>>
>>>>>>> Lorenzo, have you run into this ?
>>>>>>>
>>>>>>
>>>>>> It's hard to correlate the order since the logs are collected from two separate
>>>>>> consoles. For the write permission, I add code to the host where the permission
>>>>>> is always added for all s2 page faults in the shared space. Otherwise, qemu can
>>>>>> be killed by -EFAULT or similar error.
>>>>>
>>>>> This is the problem. We can't add WRITE permission by default. I believe
>>>>> you may have MAP_PRIVATE mapping and it has to be mapped as READ only
>>>>> and on a permission fault, we replace it with a writable page. By
>>>>> overriding the WRITE permission, you let the guest write to a page
>>>>> that may not be seen by the VMM.
>>>>>
>>>>> We identified this as a bug in the KVM driver in this series (reported
>>>>> by Lorenzo) and there is a corresponding tf-RMM change that is required
>>>>> to get this working. So, please could you wait until the next series
>>>>> when this will be addressed ? Or you could switch to using MAP_SHARED
>>>>> for the "shared" memory in the memslot.
>>>>>
>>>>
>>>> Exactly. the syntax for MAP_PRIVATE is broken if the write permission is
>>>> enforced for a read fault in the shared space. In my case, the host page can
>>>> be the zero page and eventually multiple s2 page-table entries (for multiple
>>>> unprotected or shared pages) point to the zero page. It's why clearing the
>>>> 3rd queue (Ctrl queue) also clears the first queue (Rx queue) in my case.
>>>>
>>>> Yes, this issue can be avoid by using a shared memory backend in qemu, something
>>>> like below. With this, I'm able to see virtio-net-pci starts to work...
>>>>
>>>>       -object memory-backend-ram,id=mem0,size=2G,share=yes
>>>
>>> Yes, as Suzuki said that's what we have been fixing. QEmu patches
>>> will be on the mailing lists very shortly - the KVM/tf-RMM fixes
>>> to make MAP_PRIVATE work will be included in the next posting.
>>>
>>> Feel free to drop your QEmu command line so that I can give it
>>> a shot and check whether the fixes solve the problem you hit
>>> (I think so because that's precisely the kind of issue I got
>>> into when I started debugging THP/MAP_PRIVATE but it is better
>>> to check).
>>>
>>
>> The virtio-net-pci doesn't work with the following command lines. The guest
>> kernel image is built from upstream kernel (v7.1.rc7).
>>
>>      qemu-system-aarch64 -enable-kvm -object rme-guest,id=rme0,             \
>>      -machine virt,gic-version=3,confidential-guest-support=rme0            \
>>      -cpu host,pmu=off                                                      \
>>      -smp maxcpus=2,cpus=2,sockets=1,clusters=1,cores=1,threads=2           \
>>      -m 2G -object memory-backend-ram,id=mem0,size=2G                       \
>>      -numa node,nodeid=0,cpus=0-1,memdev=mem0                               \
>>      -serial mon:stdio -monitor none -nographic -nodefaults                 \
>>      -kernel /mnt/linux/arch/arm64/boot/Image                               \
>>      -initrd /mnt/buildroot/output/images/rootfs.cpio.xz                    \
>>      -append earlycon=pl011,mmio,0x10009000000                              \
>>      -device pcie-root-port,bus=pcie.0,chassis=1,id=pcie.1                  \
>>      -device pcie-root-port,bus=pcie.0,chassis=2,id=pcie.2                  \
>>      -device pcie-root-port,bus=pcie.0,chassis=3,id=pcie.3                  \
>>      -device pcie-root-port,bus=pcie.0,chassis=4,id=pcie.4                  \
>>      -netdev tap,id=tap1,vhost=on,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown  \
>>      -device virtio-net-pci,bus=pcie.2,netdev=tap1,mac=b8:3f:d2:1d:3e:c0
> 
> Tested with private RAM backend, THP left enabled (and additional KVM and
> RMM patches that will be included in v15) looks like the net interface
> comes up cleanly.
> 
> Probably it is best to sync up on the upcoming v15 posting that I am
> testing in the background to make sure you don't spend more time chasing
> it.
> 

Thanks for your confirmation. For every respin of the arm/cca host series,
I try to give it a test to make sure nothing gets broken in my coverage.
For this specific revision (v14), more time was actually spent to rebase
Jean's qemu (branch: cca/latest) to upstream so that I can do the tests.

Lets wait for a while to see what we will have in v15 and the qemu series
you're going to post, and I will give it another try.

One unrelated question is 64KB granule size, it's not supported by upstream
TF-RMM "main" or "topics/rmm-v2.0-poc_2" branch, not sure about the plan
when this will be supported in TF-RMM. Since 64KB isn't supported by TF-RMM,
I was unable to test 64KB page size.

Upstream EDK2 doesn't support realm guest yet even some of related commits
have been merged. So I still use linaro's one at "https://git.codelinaro.org
/linaro/dcap/edk2  (branch: cca/latest).
  
Thanks,
Gavin


> Thanks,
> Lorenzo
> 
>>
>> The virtio-net-pci starts to work with the shareable memory-backend.
>>
>>      -object memory-backend-ram,id=mem0,size=2G,share=yes
>>
>> Note that THP is disabled on my host.
>>
>>      root@host:~# cat /sys/kernel/mm/transparent_hugepage/enabled
>>      always madvise [never]
> 

