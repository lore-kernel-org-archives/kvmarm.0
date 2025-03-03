Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41EF1D6DDC
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 07:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740985700; cv=none; b=Moc0bKcukwdwXSBBQAUw1GCizltDkCUHl3jUEU6JCw4ouYMPms05OIvuPubxMLc2Lhm8/cPZZOdMV+8d6EVCkhAvy29p4FIegD5G4iBoE9wPK40OgIks18ww0+HLAFE7709tCvODZenxc9BE0u1jY3Bg3GQnf/vPBM8JdsavHnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740985700; c=relaxed/simple;
	bh=AfwoLDxtt+un9QaIe0gjqSA+BcKTtkK/lo1w1S7u5uw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Szn3jOWUBX+zFWOW2i0OBZar+0r2v34/4GO2rnpkmkYu14NJo52W7zVFBAPnaASUbcXEWhN+WijHothf3HSCvTkpG5NZhhEbvhIqV63SOKSW70eeJPlP7cncTar8A3sOtSn1UTgAYT1roRG/+XooFrszIq/jhSr67IcBLyCCg2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FYImNMJq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FYImNMJq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740985697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TAZt9bZkuhMK3xl5j9Jo0Thv7hZQ7De0iSCYDAJHnkY=;
	b=FYImNMJqXUftCR+yLo7x5F7BQzqsQWS/CbFGnSsXOI6no0Qw2Td5aHSBPy6DnlqVyNs5Em
	JArMBPVl7jUoFuHE/wAkW1HqWqbuhEq9fTPlpDLmtW9fWhwl7lBLgYtoo+EG1aLnmHfv4X
	GbQ8YdIoEuWlNK10L6Z8yW2ICrewFAQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-OgK_GbvuMhqrIRZ_2CN1Ig-1; Mon, 03 Mar 2025 02:08:14 -0500
X-MC-Unique: OgK_GbvuMhqrIRZ_2CN1Ig-1
X-Mimecast-MFC-AGG-ID: OgK_GbvuMhqrIRZ_2CN1Ig_1740985693
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22367f4e9b9so50987955ad.0
        for <kvmarm@lists.linux.dev>; Sun, 02 Mar 2025 23:08:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740985693; x=1741590493;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TAZt9bZkuhMK3xl5j9Jo0Thv7hZQ7De0iSCYDAJHnkY=;
        b=pPPOG0wpyzqlPvjD+r3tBq4EDzL3hh6xpsgdRr8bsdZVqGQwz7hLtqkuNhHGx5czVe
         joHlaL9B5Yvev027BuVRDxpH6Dk4if8De/3krpL1VWEtRAdiW/MbqoGTb//giWC5xPpd
         JG/N039+OLm9Tlg14l3agReP3DJw6AsOFgtYhea0/drUvDODfR/9ncmkBK8vJKAHe4FS
         Bogb1M+pvOIIY3VWJmpUZXX+i4mWluDZM8u+cUO/4/gRznz+5Qhl72jioGfX2WhR+TJ2
         /Lwakb46DQfip5F4SG7ll9sSsvVpbba65MF6U3IGZb/tgxYRRVpo6t1yuc6LM3fB+RzP
         mrCA==
X-Forwarded-Encrypted: i=1; AJvYcCVfzNWQwJ3IE3o8byQRdIiWO9tnJoR/OEM+6L0Pn9W+9hD0HQUTuZiBS7aOKwJ0HyMtpe6KfEs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzg653YJ22Ub+e2djXncd4TA1t7HrHGUnXoiwbt5MeNfH+2phmf
	KB8YQTrmuOi6yBw2+2HDikssjrLzQNxGEG/d/PqIRb2a3mIKKHy5lTMM9EiZ3TyVQ1z6sRBZYgg
	/N7Eg/5Ws6txnoPGgyIUQMdueJ2tm5qXlYG/npAhbyM3E90WbKKN5RQ==
X-Gm-Gg: ASbGncvQu0yYdlHs06dFYArR/gTx9yKPs0JrtQEJYp6ciOU/ONzbOBGCpwoNhZB78HB
	wxUHBplMV3IcHuDoU78qrD9wbP+g2TAEAZ2r7rcqcsou3McnNH1Dj2VHbijwphqnj8rFDmooPFN
	jcsZ7skF9eWk93QO0LMeWxzPlAZiVQ4mzlofCYuj+TV7FAqdzh+McOOy6AAwhvhrxAnqvR42lKm
	COrsWFQAqHjEMfP7GkaKH81Y4ip/8fy4chsl/0bQxjcaX+q0c7uopbJBPfx718Qdv/Bt/ZHK2NR
	6y5gJmtLPGiJzWhLdw==
X-Received: by 2002:a17:902:c951:b0:221:78a1:27fb with SMTP id d9443c01a7336-22368f72060mr189619795ad.11.1740985693559;
        Sun, 02 Mar 2025 23:08:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFj6AXAjs67EIGwQMhzQQGbQbpNnv+WHLAlTElHzKGobUYvRKx1SI4QHA9TpJnCJTfgJ55bPw==
X-Received: by 2002:a17:902:c951:b0:221:78a1:27fb with SMTP id d9443c01a7336-22368f72060mr189619505ad.11.1740985693207;
        Sun, 02 Mar 2025 23:08:13 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223504c5cd2sm71285075ad.143.2025.03.02.23.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 23:08:12 -0800 (PST)
Message-ID: <7639eca7-8fd8-491c-90bd-1be084fbd710@redhat.com>
Date: Mon, 3 Mar 2025 17:08:04 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/45] arm64: RME: Allocate/free RECs to match vCPUs
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-13-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-13-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: av9_sIqiAX__Skd8SgPg3dZZUtUaROQGJGF02WhRqy0_1740985693
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> The RMM maintains a data structure known as the Realm Execution Context
> (or REC). It is similar to struct kvm_vcpu and tracks the state of the
> virtual CPUs. KVM must delegate memory and request the structures are
> created when vCPUs are created, and suitably tear down on destruction.
> 
> RECs must also be supplied with addition pages - auxiliary (or AUX)
> granules - for storing the larger registers state (e.g. for SVE). The
> number of AUX granules for a REC depends on the parameters with which
> the Realm was created - the RMM makes this information available via the
> RMI_REC_AUX_COUNT call performed after creating the Realm Descriptor (RD).
> 
> Note that only some of register state for the REC can be set by KVM, the
> rest is defined by the RMM (zeroed). The register state then cannot be
> changed by KVM after the REC is created (except when the guest
> explicitly requests this e.g. by performing a PSCI call). The RMM also
> requires that the VMM creates RECs in ascending order of the MPIDR.
> 
> See Realm Management Monitor specification (DEN0137) for more information:
> https://developer.arm.com/documentation/den0137/
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Avoid reporting the KVM_ARM_VCPU_REC feature if the guest isn't a
>     realm guest.
>   * Support host page size being larger than RMM's granule size when
>     allocating/freeing aux granules.
> Changes since v5:
>   * Separate the concept of vcpu_is_rec() and
>     kvm_arm_vcpu_rec_finalized() by using the KVM_ARM_VCPU_REC feature as
>     the indication that the VCPU is a REC.
> Changes since v2:
>   * Free rec->run earlier in kvm_destroy_realm() and adapt to previous patches.
> ---
>   arch/arm64/include/asm/kvm_emulate.h |   7 ++
>   arch/arm64/include/asm/kvm_host.h    |   3 +
>   arch/arm64/include/asm/kvm_rme.h     |  18 +++
>   arch/arm64/kvm/arm.c                 |  13 +-
>   arch/arm64/kvm/reset.c               |  11 ++
>   arch/arm64/kvm/rme.c                 | 179 +++++++++++++++++++++++++++
>   6 files changed, 229 insertions(+), 2 deletions(-)
> 

With the following one comment addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

[...]

>   
>   /*
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 698bb48a8ae1..5db377943db4 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -6,6 +6,7 @@
>   #ifndef __ASM_KVM_RME_H
>   #define __ASM_KVM_RME_H
>   
> +#include <asm/rmi_smc.h>
>   #include <uapi/linux/kvm.h>
>   
>   /**
> @@ -65,6 +66,21 @@ struct realm {
>   	unsigned int ia_bits;
>   };
>   
> +/**
> + * struct realm_rec - Additional per VCPU data for a Realm
> + *
> + * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify this VCPU
> + * @rec_page: Kernel VA of the RMM's private page for this REC
> + * @aux_pages: Additional pages private to the RMM for this REC
> + * @run: Kernel VA of the RmiRecRun structure shared with the RMM
> + */
> +struct realm_rec {
> +	unsigned long mpidr;
> +	void *rec_page;
> +	struct page *aux_pages[REC_PARAMS_AUX_GRANULES];
> +	struct rec_run *run;
> +};
> +

REC_PARAMS_AUX_GRANULES represents the maximal number of the auxiliary granules.
Since the base page size is always larger than or equal to granule size (4KB).
The capacity of array @aux_pages[] needs to be REC_PARAMS_AUX_GRANULES. Ideally,
the array's size can be computed dynamically and it's allocated in kvm_create_rec().

Alternatively, to keep the code simple, a comment is needed here to explain why
the array's size has been set to REC_PARAMS_AUX_GRANULES.

An relevant question: Do we plan to support differentiated sizes between page
and granule? I had the assumption this feature will be supported in the future
after the base model (equal page and granule size) gets merged first.

Thanks,
Gavin

