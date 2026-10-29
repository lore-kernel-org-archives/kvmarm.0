Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.221
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793282543;
	b=OtSOSIiEMjICaOiv6bI/Q33zIt9XCkEf83+KbEQPIX2YZnr+W6cKUZ4UD6Q5ioMX6yZt
	 iCErY7mXieoJ6IbMGI9umO3hFITPSlCAIBTpn7K4OoekWOFwuZricOFdkzKXzMPUeQbjV
	 gQTwZf+sQ5QFRza+6uSTSDBbGoaIYaGbXO/Ux4Vve7GoA2muTsbLj8173yHJ+tq6A2SJw
	 o+TZyZpfOwgUk8TpFEFEHdFtjswO0Y5DQxpK2uH470/pQpunqZ4mmAWnETaMdp0DfgBBn
	 aCZRgDqRjyXvS8L05mnIbCml/3plOEFqV0SQbyAt/MsQ4VJQCQobri4IktUQfpFJtRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793282543;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=46BTS2L17vKUMaAXzO89PlCn4e9X2ecYyyZ5hRRDLBc=;
	b=Ek1kML0o+EO8jp2Or9/xAbZJVvG95dSiUm6yOhwX3xz4CE0iIUJLVbffpW/v61KEzXGJ
	 Lv8AC6Z4/WF5ucYxGalFfakBBecz8XC4QnWGLq38yl0CK55T/S0JXBdqMI1iZPYef66Du
	 fEI8+y0Fxtk4shP2v6Y+G6vRnPvIH48rhUNz4l2FeCtqbSwzOkwpizmVrvtr8P3K11iy8
	 USaqEXXPABVUVXV/PozDVZIfy9UNUoQh3aAcElP2Q6EVTdxr/1+a1f6I2KIRlRU5a+fIC
	 g9q59JoDQ1lW7ZQcCnnR0AteugS7aQPltO0psRjy1yCS0fxKBMUHKMG8dKDAcRizc5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Xxcr1uEv;
	arc=none smtp.remote-ip=113.46.200.221
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45BE606A332
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 14:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C45BE606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Xxcr1uEv
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=46BTS2L17vKUMaAXzO89PlCn4e9X2ecYyyZ5hRRDLBc=;
	b=Xxcr1uEvjyUncblEyLuJ13eru1beYW/GY5GFrPE5ZiK43B4KlA7E+sfVr4qhA3hrvIBxIwDSM
	8bbmRWDAsZAUJOf4aPz+Fkbsf8dlBiYZwCbJ4LCU36/fQiGVBZ8WrYc5WWyoqZLYFc7PE1SX2xp
	egChEha82ieFCMIiUlrLwNo=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4jFmBT2KpwzRhQX;
	Thu, 29 Oct 2026 22:02:09 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 162B340561;
	Thu, 29 Oct 2026 22:02:12 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 29 Oct 2026 22:02:10 +0800
Message-ID: <009b13c6-f618-43fe-8a56-8519d31b239b@huawei.com>
Date: Thu, 29 Oct 2026 22:02:10 +0800
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/15] KVM: arm64: Harvest stage-2 dirty state into the
 host folio account
To: Leonardo Bras <leo.bras@arm.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>,
	<caijian11@h-partners.com>, <liuyonglong@huawei.com>,
	<tangchengchang@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <fuad.tabba@linux.dev>, <mark.rutland@arm.com>,
	<seanjc@google.com>, <rdunlap@infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <skhan@linuxfoundation.org>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-6-zhengtian10@huawei.com> <at-WceRKAVM2kEnI@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <at-WceRKAVM2kEnI@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 10/27/2026 2:05 AM, Leonardo Bras wrote:
> Hi Tian,
> Sorry for the delay in reviewing...
> 
> On Tue, Sep 29, 2026 at 06:36:45PM +0800, Tian Zheng wrote:
>> With VTCR_EL2.HD set, hardware promotes writable-clean descriptors to
>> writable-dirty without any VM exit, and the only record of the write
>> is the S2AP[1] bit in the stage-2 PTE. The write never passed through
>> the host stage-1, and no unmap path reads the bit, so the record dies
>> with the PTE and reclaim may discard written guest data (silent
>> corruption).
> 
> Sorry, I didn't get what you are trying to achieve here.
> 
> On your patch, I see you marking backing pages dirty at wrprotect and unmap
> walkers, and it's very confusing to me on why you are doing this.
> 
> IIUC, what you are trying to do is make sure a page does not lose it's
> contents in case it is reclaimed by the OS.
> 
> IIUC, when a page is reclaimed, it will unmap the S2 PTE, and save it's
> contents to swap, so when the guest read or write to that page will cause
> it to fault.
> 
> The page can never be just unmaped, as if there was a single write to it,
> the backing pages should be writable, and the contents need to be saved
> somewhere.
> 
> So, if I was able to understand your suggestion, we don't need to worry
> about this, and this patch wouldn't be necessary.
> 
> Did you hit this issue?
> Can you please expand on your issue, if I could not describe it above?
> 
> Thanks!
> Leo

Hi Leo,

Thanks for the review. I haven't hit this in practice, and based on your
analysis the patch doesn't look necessary.

Reclaim only writes back folios whose PG_dirty flag is set; a clean
folio is simply freed. A stage-2 write never touches the host
stage-1, so the folio depends entirely on kvm_release_faultin_page()
at fault-in to be marked as dirty; without it, the page stays clean from
the host's perspective and reclaim drops the data.

Your **RFC v1** patch 2 changed that marking from writable to dirty:

```
- kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
+ kvm_release_faultin_page(kvm, s2vi->page, !!ret, dirty);
```

During logging, a read fault maps the page as WC: the folio is not
marked PG_dirty in kvm_s2_fault_map() and hardware promotes the PTE to
WD on write without any fault, so reclaim frees the page without saving
it (the folio was treated as clean).

Therefore, **HDBSS v5** patch 2 reverted to marking the folio for any
write-permitting mapping:

```
kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
```

Together with the v5 scheme, this makes patch 5 unnecessary:

- kvm_s2_fault_compute_prot: always set PROT_W when map_writable
- stage2_set_prot_attr: PROT_W -> DBM unconditionally


---------

On a related note, I'd like to discuss the next version of the DBM
scheme, following Oliver's suggestion [1].

Oliver asked for the write bit to be selected by the system capability:

	FEAT_HAFDBS: PROT_W => DBM, PROT_DIRTY => S2AP[1]
	!FEAT_HAFDBS: both => S2AP[1]

However, our v5 kvm_s2_fault_compute_prot() granted PROT_W
unconditionally. With PROT_W => S2AP[1] on !FEAT_HAFDBS, a read fault on
a dirty-tracked memslot would install a writable page. Since dirty-
logging relies on the write fault to observe the page, we would fail to
track it.

So we also need to fix kvm_s2_fault_compute_prot():

```
if (s2vi->map_writable) {
         if (s2vi->device ||
             !memslot_is_logging(s2fd->memslot) ||
             kvm_is_write_fault(s2fd->vcpu)) {
                 *prot |= KVM_PGTABLE_PROT_W |
                          KVM_PGTABLE_PROT_DIRTY;
         } else if (kvm_supports_hafdbs()) {
                 *prot |= KVM_PGTABLE_PROT_W;
         }
}
```

For normal RAM on a system without FEAT_HAFDBS:

	logging + read fault  -> PTE read-only
	logging + write fault -> PTE S2AP[1]=1

[1] 
https://lore.kernel.org/all/ff218960-c412-4283-aa41-b7af2a7048b8@huawei.com/

Thanks,
Tian
