Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4962264D3
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 18:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781201389; cv=none; b=nLwemG9evnu8N9kINh8QwNuA0HjbCG9br3Udo0JY9ZlYATRVIXpZCy6cVT8usvv5eENBPVP9RMIfWIqlc1Q7ZBulGUZf4k43J7krinHFSaCmQ8Gi0R6/RepoKXRCDqFJxKbT8YL7R18ddRSFncE+flrmr+7rq0K+dUM7XwaYbeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781201389; c=relaxed/simple;
	bh=VcgDa06fzQtdVQCPgByMypvXqjIa/zq4mgwGqeVy/0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sHudlFgaNr2iAVoEu81EvV9ZEiCidHQ7E/N1gTzg0giGjkBJnJyb9Quvs7rOgQIDQxj+OJSxUjRRxLL3jehZ0QywtOJ3i9NoAl2gchSbY+Fj62pQzm32v3lcrKDsGcIr7zC4X3EivS/W+dydueh75hZ3y4/fkOKP0BjR5VSBWDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cfE7MfGH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cfE7MfGH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781201386;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bw2WstwxYZHVqC05oy8JKd4Zcnu7Fyd9gY5xNtb280s=;
	b=cfE7MfGH2N7z+GT5MGo92yKPHl7f2YgbBU1HCsmDImpnP74HSQEZaZPphLlVI9JXJjKu1s
	aIQCJyjNM4fN4wmaPInm7+G+2HzdB/cjS0iUioADAkMYp8OahuO6zljHuYbvFsgsyy0+tp
	JIYRYGHUqi2KZFvhVklAsavxH4qOXXU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-9dY0SsExM76IfH-XSPD8zA-1; Thu, 11 Jun 2026 14:09:44 -0400
X-MC-Unique: 9dY0SsExM76IfH-XSPD8zA-1
X-Mimecast-MFC-AGG-ID: 9dY0SsExM76IfH-XSPD8zA_1781201383
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490d3f03883so819725e9.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 11:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781201383; x=1781806183;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bw2WstwxYZHVqC05oy8JKd4Zcnu7Fyd9gY5xNtb280s=;
        b=FSMtvM+umpjzVcK+PUoh8/O95eNxf1pzIZZo+PxihYNJ0rXBYDJHUEkQt5yjMclvM1
         1nsU45C+kqZUpp46gOW4jRzklhUdYoSfqNZgpxBG73nN8VlULDmI9mREUrN+vOdsSLY4
         Ps3iCxL6e20hsApcoVjzF2aIshznQRuCaFlxov3EKm69JAVBgth/EvJ/C2gHRtA5RJec
         zkOZ8eN4JhVQfJxxMkXxrwBwGvLrsP8Res0wKLgV+qLQEViK8t1L07wkJacXhxE7mgg+
         5rC1VjR5eIsgK7hY9mZ+mY9kk7Rv42cByD9hX/hwM7/sII/bS3UazyR3BYd1sdddfnVV
         F8/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+Zq/gj70VUw6z76Z5Se1N1PKVDylCbFMHT+TxEWw0jc5hsl7jzBwrmkqNAOPmZu5fIVny2OoE=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywh1oqvq7Clf/3iWDb8XkcSXC2Eedpp1FLRun2PUkJiFHgZAUHE
	ZFzAERjJKuXHHaPKauoq4b5vkB/69mb5n9WPQTjoiDjZ5mb7aTx7EQdMMgKcJjInH/b+0od1YXi
	d3DIKRrj01XMLrwn+htzHraDIiayyySQDV3Xxbr0O+n/0s6t7YvwSxwV4KA==
X-Gm-Gg: Acq92OF7g0Mt9M6ossbJWJBA9PI9lSu16wKNDlW+V4yFhzchwnDPgApKGvkM3yO5+O8
	gkXyTfqxq2Ityu/j5BUcVfFxqPO+21uOdviD2pn3MZ+ZoLE5mXC2QSUNUVIfbqoTMg0oGytguq0
	JPyUazMITVxcVGzqyqMO1ZNIiNydI8aeitivyaSrqQobzDzATbf5IrIljuSqzbDCZyTVlcu5bfb
	qqQBdkfw2koLs8vgMDDr4HKKXTE+f+OK5ofQBNRtOquxpO79TeL82gozwSy9Xu3nkcMFni+2SGT
	G/aayDdrglA4hBFo2N50MVUTmWn/7ut8ehMUccicmecyFSpdmV0n/LHHvZS0eVNbUVhWAtG+FZA
	IZgl86izHf+cvoHdBUPVL8mZ4CtOQBpUMZZpHJ40RDPDw1f3whqK6/f059lw8kVm+5U2goA==
X-Received: by 2002:a05:600c:6208:b0:490:ae94:a7e6 with SMTP id 5b1f17b1804b1-490e561d45amr67430275e9.24.1781201383032;
        Thu, 11 Jun 2026 11:09:43 -0700 (PDT)
X-Received: by 2002:a05:600c:6208:b0:490:ae94:a7e6 with SMTP id 5b1f17b1804b1-490e561d45amr67429665e9.24.1781201382558;
        Thu, 11 Jun 2026 11:09:42 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea4b41c7sm3413515e9.1.2026.06.11.11.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 11:09:41 -0700 (PDT)
Message-ID: <528ce8c1-dcec-45bd-9a50-c4c21529f812@redhat.com>
Date: Thu, 11 Jun 2026 20:09:38 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC] arm: property and value naming summary between named CPU
 models vs customizable host model
To: Khushit Shah <khushit.shah@nutanix.com>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc: "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 Jinqian Yang <yangjinqian1@huawei.com>, Marc Zyngier <maz@kernel.org>,
 Sebastian Ott <sebott@redhat.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
References: <B820643E-3F14-4CDA-BA6B-09C632F17B9E@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <B820643E-3F14-4CDA-BA6B-09C632F17B9E@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fl3WjSiPYsdAEz5Y9zw_XWU6l-I1e1Vdino6tcpSP6c_1781201383
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 6/10/26 2:31 PM, Khushit Shah wrote:
> Hi everyone,
>
> Posting the summary of the differences in property/value names and types used
> in named CPU model RFCs [1] and in the customizable host model series [2].

thank you very much for the synthesis.
>
> [1]: (v1) https://lore.kernel.org/qemu-arm/20260513163356.3033159-1-shaju.abraham@nutanix.com/ 
> [1]: (v2) https://lore.kernel.org/qemu-arm/20260605083358.1320563-1-khushit.shah@nutanix.com/
> [2]: (v6)  https://lore.kernel.org/qemu-devel/20260519132905.145643-1-eric.auger@redhat.com/
>
> [2] defines all ID register field level properties, [1] also defines the 
> same field-level properties with some extra sugar.
>
> Approach for CPU Properties in [2]:
>
> Notably, [2] is simpler: a property name follows this convention:
> SYSREG_<ID_REGISTER_NAME>_<FIELD_NAME> and the property values are of type
> u64. A property for a field is added to the CPU object only if the field is
> writable. This means no extra work on the QEMU side when KVM starts
> exposing a new field as writable.
>
> So, say you want to set AES capability for the guest, then you say:
> -cpu host,SYSREG_ID_AA64ISAR0_AES=0/1/2
>
> Approach for CPU Properties in [1]:
> [1] also works on field-based properties. But uses a different convention
> for property names:
>     - for a field that maps 1:1 with ARM ARM FEAT_Xs, define the property
>       name as feat_<FieldName>, for example, ID_AA64ISAR0.AES maps cleanly
>       with FEAT_AES and FEAT_PMULL. Property names for ID_AA64ISAR0.AES,
>       will be feat_AES.
don't you want to also expose feat_PMULL too? In that case ARM ARM
specifies 2 features which are advertised by the same ID reg field. Why
would you advertise one FEAT and not the other? 

In that case the spec says:

0b0000 No AES instructions implemented.
0b0001 AESE, AESD, AESMC, and AESIMC instructions implemented.
0b0010 As for 0b0001, plus PMULL and PMULL2 instructions operating on
64-bit source elements.

FEAT_AES implements the functionality identified by the value 0b0001.
FEAT_PMULL implements the functionality identified by the value 0b0010


>     - for a field that does not cleanly map 1:1 with any ARM ARM FEATs,
>       define the property name as hw_prop_<FieldName>, for example 
>       ID_AA64MMFR0.TGRAN16, CTR_EL0.L1IP, etc., are named like
>       hw_prop_TGRAN16, hw_prop_L1IP, etc.
you may add that the feature mapping is inspired of the kernel
arch/arm64/kvm/kernel/cpufeature.c arm64_ftr_regs[]
You used it to easily identify which fields correspond to feature and
also to extract some other data which are not dealt with in the summary
(safe rule and safe value)
>
> [1] does not generate properties automatically; each property we want to
> add must be added manually.
>
> Property value types in [1]:
> - string properties: for fields which have arch-defined values.
>
>   String values are derived from the kernel's sysreg file, for example,
>   for the field ID_AA64ISAR1.LS64, the sysreg file has
>         UnsignedEnum    63:60   LS64
>                 0b0000  NI
>                 0b0001  LS64
>                 0b0010  LS64_V
>                 0b0011  LS64_ACCDATA
>                 0b0100  LS64WB
>         EndEnum
>
>  In QEMU, the value names are "off", "ls64", "ls64_v”, “ls64_accdata"
>  and "ls64wb". Which also closely match the manual:
you may add that those string values are not specified in ARM ARM. This
is the result of some human processing with possible distortion:

In that case spec says:

0b0000 No LD64B or ST64B instructions are supported.
0b0001 The LD64B and ST64B instructions are supported.
0b0010 As 0b0001, and adds the ST64BV instruction and traps.
0b0011 As 0b0010, and adds the ST64BV0 instruction, ACCDATA_EL1
register, and traps.
0b0100 As 0b0011, and adds support for atomic accesses to Write-back
Cacheable, Shareable memory using one of the following:
     • LD64B and ST64B instructions. • SIMD&FP instructions that load or
store a pair of 128-bit registers by generating 32-byte single-copy
atomic accesses.

Documentation/arch/arm64/cpu-feature-registers.rst documents the ABI for
exporting CPU/ID/feature regs. Those values are not defined there. Is
there any place where those values are documented besides sysreg?

>
>         FEAT_LS64 implements the functionality identified by 0b0001.
>         FEAT_LS64_V implements the functionality identified by 0b0010.
>         FEAT_LS64_ACCDATA implements the functionality identified by 0b0011.
>         FEAT_LS64WB implements the functionality identified by 0b0100.
>
>  In most of the cases, as seen in the Appendix, this works very well.
>
> - u64 properties: for fields which have no arch-defined values, like cache
>    size, debug registers, CPU revision, etc...
> - bool properties: for single-bit fields.
> - Fractional(string) properties: for fields like CSV2 and CSV2_FRAC that
>    collectively decide on a feature version. This helps in preventing invalid
>    configuration like CSV2=0 while CSV2_FRAC=1.
>
> The property and value names for [1] are still open to bikeshedding. I have
> left composites out of this comparison as they are a convenience, and only
> defined for named models.
>
> I have tried to keep the comparison above neutral, but Eric/Cornelia can
> add more. I see real merit in [2]'s simplicity and generalization. But
> for [1], I love a command line that looks like:
> -cpu host,feat_DP=off,feat_AES=off,feat_RAS=0.0,...
>
> instead of:
> -cpu host \
>      SYSREG_ID_AA64ISAR0_DP=0,\
>      SYSREG_ID_AA64ISAR0_AES=0,\
>      SYSREG_ID_AA64PFR0_RAS=0,\
>      SYSREG_ID_AA64PFR1_RAS_FRAC=0 
>
> I have no strong preference on this topic. The named CPU model layer is
> independent of whichever convention we choose here, so I'd like the
> community to decide which direction makes the most sense :)
>
> The Appendix below lists all currently defined properties in [1] and their
> named values.

I would like to add that in [2] we generate all the data from AARCHMRS
registers.json (machine readable spec from ARM). In earlier versions we
also used kernel sysreg as source of truth and we got the feedback from
Marc to try using the MRS instead. The introduction of string values for
some of the props break that attempt because as I explained earlier
those string values are not defined in the spec and therefore cannot be
extracted from the MRS.

Maybe we shall further look at what can be extracted from AARCHMRS
Features.json. 
>
> Warm Regards,
> Khushit
>
> Appendix:
> ==================
> all currently defined properties in [1]:
>
> feat_AES (ID_AA64ISAR0.AES): off, aes, pmull
> feat_AFP (ID_AA64MMFR1.AFP): off, on
> feat_AMU (ID_AA64PFR0.AMU): off, on, v1p1
> feat_AT (ID_AA64MMFR2.AT): off, on
> feat_ATOMIC (ID_AA64ISAR0.ATOMIC): off, on, LSE128
> feat_AdvSIMD (ID_AA64PFR0.ADVSIMD): on, fp16, off
> feat_BBM (ID_AA64MMFR2.BBM): 0, 1, 2
> feat_BC (ID_AA64ISAR2.BC): off, on
> feat_BF16 (ID_AA64ISAR1.BF16): off, on, ebf16
> feat_BIGEND (ID_AA64MMFR0.BIGEND): off, on
> feat_BIGENDEL0 (ID_AA64MMFR0.BIGENDEL0): off, on
> feat_BT (ID_AA64PFR1.BT): off, on
> feat_CLRBHB (ID_AA64ISAR2.CLRBHB): off, on
> feat_CNP (ID_AA64MMFR2.CNP): off, on
> feat_CRC32 (ID_AA64ISAR0.CRC32): off, on
> feat_CSSC (ID_AA64ISAR2.CSSC): off, on, cmpbr
> feat_CSV3 (ID_AA64PFR0.CSV3): off, on
> feat_DBG (ID_AA64DFR0.DEBUGVER): on, vhe, v8p2, v8p4, v8p8, v8p9
> feat_DF2 (ID_AA64PFR1.DF2): off, on
> feat_DGH (ID_AA64ISAR1.DGH): off, on
> feat_DIT (ID_AA64PFR0.DIT): off, on
> feat_DP (ID_AA64ISAR0.DP): off, on
> feat_DPB (ID_AA64ISAR1.DPB): off, on, dpb2
> feat_DoubleLock (ID_AA64DFR0.DOUBLELOCK): on, off
> feat_E0PD (ID_AA64MMFR2.E0PD): off, on
> feat_E2H0 (ID_AA64MMFR4.E2H0): on, ni_nv1, off
> feat_ECBHB (ID_AA64MMFR1.ECBHB): off, on
> feat_ECV (ID_AA64MMFR0.ECV): off, on, cntpoff
> feat_ETS (ID_AA64MMFR1.ETS): off, on, ets2, ets3
> feat_EVT (ID_AA64MMFR2.EVT): off, on, ttlbxs
> feat_EXS (ID_AA64MMFR0.EXS): off, on
> feat_F8CVT (ID_AA64FPFR0.F8CVT): off, on
> feat_F8DP2 (ID_AA64FPFR0.F8DP2): off, on
> feat_F8DP4 (ID_AA64FPFR0.F8DP4): off, on
> feat_F8E4M3 (ID_AA64FPFR0.F8E4M3): off, on
> feat_F8E5M2 (ID_AA64FPFR0.F8E5M2): off, on
> feat_F8FMA (ID_AA64FPFR0.F8FMA): off, on
> feat_F8MM4 (ID_AA64FPFR0.F8MM4): off, on
> feat_F8MM8 (ID_AA64FPFR0.F8MM8): off, on
> feat_FAMINMAX (ID_AA64ISAR3.FAMINMAX): off, on
> feat_FCMA (ID_AA64ISAR1.FCMA): off, on
> feat_FGT (ID_AA64MMFR0.FGT): off, on, fgt2
> feat_FHM (ID_AA64ISAR0.FHM): off, on
> feat_FP (ID_AA64PFR0.FP): on, fp16, off
> feat_FPMR (ID_AA64PFR2.FPMR): off, on
> feat_FPRCVT (ID_AA64ISAR3.FPRCVT): off, on
> feat_FRINTTS (ID_AA64ISAR1.FRINTTS): off, on
> feat_GCS (ID_AA64PFR1.GCS): off, on
> feat_HAFDBS (ID_AA64MMFR1.HAFDBS): off, af, dbm, haft, hdbss
> feat_HCX (ID_AA64MMFR1.HCX): off, on
> feat_HPDS (ID_AA64MMFR1.HPDS): off, on, hpds2
> feat_I8MM (ID_AA64ISAR1.I8MM): off, on
> feat_IESB (ID_AA64MMFR2.IESB): off, on
> feat_JSCVT (ID_AA64ISAR1.JSCVT): off, on
> feat_LO (ID_AA64MMFR1.LO): off, on
> feat_LRCPC (ID_AA64ISAR1.LRCPC): off, on, lrcpc2, lrcpc3
> feat_LS64 (ID_AA64ISAR1.LS64): off, ls64, ls64_v, ls64_accdata, ls64wb
> feat_LSFE (ID_AA64ISAR3.LSFE): off, on
> feat_LSM (ID_AA64MMFR2.LSM): off, on
> feat_LUT (ID_AA64ISAR2.LUT): off, on
> feat_MOPS (ID_AA64ISAR2.MOPS): off, on
> feat_MTE (ID_AA64PFR1.MTE): off, on, mte2, mte3
> feat_MTEFAR (ID_AA64PFR2.MTEFAR): off, on
> feat_MTESTOREONLY (ID_AA64PFR2.MTESTOREONLY): off, on
> feat_MTE_FRAC (ID_AA64PFR1.MTE_FRAC): async, off
> feat_NMI (ID_AA64PFR1.NMI): off, on
> feat_PAN (ID_AA64MMFR1.PAN): off, on, pan2, pan3
> feat_PMU (ID_AA64DFR0.PMUVER): off, on, v3p1, v3p4, v3p5, v3p7, v3p8, v3p9, imp_def
> feat_RDM (ID_AA64ISAR0.RDM): off, on
> feat_RNDR (ID_AA64ISAR0.RNDR): off, on
> feat_RPRES (ID_AA64ISAR2.RPRES): off, on
> feat_RPRFM (ID_AA64ISAR2.RPRFM): off, on
> feat_S1PIE (ID_AA64MMFR3.S1PIE): off, on
> feat_S1POE (ID_AA64MMFR3.S1POE): off, on
> feat_SB (ID_AA64ISAR1.SB): off, on
> feat_SCTLRX (ID_AA64MMFR3.SCTLRX): off, on
> feat_SEL2 (ID_AA64PFR0.SEL2): off, on
> feat_SHA1 (ID_AA64ISAR0.SHA1): off, on
> feat_SHA2 (ID_AA64ISAR0.SHA2): off, sha256, sha512
> feat_SHA3 (ID_AA64ISAR0.SHA3): off, on
> feat_SM3 (ID_AA64ISAR0.SM3): off, on
> feat_SM4 (ID_AA64ISAR0.SM4): off, on
> feat_SNSMEM (ID_AA64MMFR0.SNSMEM): off, on
> feat_SPECRES (ID_AA64ISAR1.SPECRES): off, on, cosp_rctx
> feat_SSBS (ID_AA64PFR1.SSBS): off, on, ssbs2
> feat_SVE (ID_AA64PFR0.SVE): off, on
> feat_SVE_AES (ID_AA64ZFR0.AES): off, on, pmull128, aes2
> feat_SVE_B16B16 (ID_AA64ZFR0.B16B16): off, on, bfscale
> feat_SVE_BFLOAT16 (ID_AA64ZFR0.BFLOAT16): off, on, ebf16
> feat_SVE_BITPERM (ID_AA64ZFR0.BITPERM): off, on
> feat_SVE_ELTPERM (ID_AA64ZFR0.ELTPERM): off, on
> feat_SVE_F16MM (ID_AA64ZFR0.F16MM): off, on
> feat_SVE_F32MM (ID_AA64ZFR0.F32MM): off, on
> feat_SVE_F64MM (ID_AA64ZFR0.F64MM): off, on
> feat_SVE_I8MM (ID_AA64ZFR0.I8MM): off, on
> feat_SVE_SHA3 (ID_AA64ZFR0.SHA3): off, on
> feat_SVE_SM4 (ID_AA64ZFR0.SM4): off, on
> feat_SpecSEI (ID_AA64MMFR1.SPECSEI): off, on
> feat_TCRX (ID_AA64MMFR3.TCRX): off, on
> feat_TIDCP1 (ID_AA64MMFR1.TIDCP1): off, on
> feat_TLB (ID_AA64ISAR0.TLB): off, os, range
> feat_TS (ID_AA64ISAR0.TS): off, flagm, flagm2
> feat_TTL (ID_AA64MMFR2.TTL): off, on
> feat_TWED (ID_AA64MMFR1.TWED): off, on
> feat_UAO (ID_AA64MMFR2.UAO): off, on
> feat_VH (ID_AA64MMFR1.VH): off, on
> feat_WFXT (ID_AA64ISAR2.WFXT): off, on
> feat_XNX (ID_AA64MMFR1.XNX): off, on
> feat_XS (ID_AA64ISAR1.XS): off, on
in [1] you have properties for fields which are not writable in the
kernel whereas [2] exposes a reduced set of props, only for writable
fields. 
>
> Exceptions, because feat_ELx seemed wrong:
> el0_mode (ID_AA64PFR0.EL0): aarch64, aarch32
> el1_mode (ID_AA64PFR0.EL1): aarch64, aarch32
> el2_mode (ID_AA64PFR0.EL2): off, aarch64, aarch32
> el3_mode (ID_AA64PFR0.EL3): off, aarch64, aarch32
>
> CPU identification props:
> cpu_aidr (AIDR.VAL): u64
> cpu_architecture (MIDR.ARCHITECTURE): u64
> cpu_implementer (MIDR.IMPLEMENTER): u64
> cpu_partnum (MIDR.PARTNUM): u64
> cpu_revidr (REVIDR.VAL): u64
> cpu_revision (MIDR.REVISION): u64
> cpu_variant (MIDR.VARIANT): u64
>
> Fractional:
> feat_RAS (Fractional ID_AA64PFR0.RAS, ID_AA64PFR1.RAS_FRAC):
>     0.0, 1.0, 1.1, 1.1_base, 2.0
> feat_CSV2 (Fractional ID_AA64PFR0.CSV2, ID_AA64PFR1.CSV2_FRAC):
>     0.0, 1.0, 1.1, 1.2, 2.0, 3.0
> feat_MPAM (Fractional ID_AA64PFR0.MPAM, ID_AA64PFR1.MPAM_FRAC):
>     0.0, 0.1, 1.0, 1.1
> feat_NV (Fractional ID_AA64MMFR2.NV, ID_AA64MMFR4.NV_FRAC):
>     0.0, nv2_only, 1.0, 2.0, 2.0_only, 2.1
>
> Properties for fields not cleanly mapping 1:1 to any ARM FEAT_x:
> hw_prop_APA (ID_AA64ISAR1.APA): off, pauth, epac, pauth2, fpac, fpaccombine, pauth_lr
> hw_prop_APA3 (ID_AA64ISAR2.APA3): off, pauth, epac, pauth2, fpac, fpaccombine, pauth_lr
> hw_prop_API (ID_AA64ISAR1.API): off, pauth, epac, pauth2, fpac, fpaccombine, pauth_lr
> hw_prop_CCIDX (ID_AA64MMFR2.CCIDX): 32, 64
> hw_prop_FWB (ID_AA64MMFR2.FWB): off, on
> hw_prop_GPA (ID_AA64ISAR1.GPA): off, on
> hw_prop_GPA3 (ID_AA64ISAR2.GPA3): off, on
> hw_prop_GPI (ID_AA64ISAR1.GPI): off, on
> hw_prop_IDS (ID_AA64MMFR2.IDS): 0x0, 0x18
> hw_prop_L1IP (CTR_EL0.L1IP): reserved_vpipt, reserved_aivivt, vipt, pipt
> hw_prop_PARANGE (ID_AA64MMFR0.PARANGE): 32, 36, 40, 42, 44, 48, 52, 56
> hw_prop_PMSVer (ID_AA64DFR0.PMSVER): off, on, v1p1, v1p2, v1p3, v1p4, v1p5
> hw_prop_ST (ID_AA64MMFR2.ST): 39, 48_47
> hw_prop_SVEVer (ID_AA64ZFR0.SVEVER): on, sve2, sve2p1, sve2p2
> hw_prop_TGRAN16 (ID_AA64MMFR0.TGRAN16): off, on, 52_bit
> hw_prop_TGRAN16_2 (ID_AA64MMFR0.TGRAN16_2): tgran16, off, on, 52_bit
> hw_prop_TGRAN4 (ID_AA64MMFR0.TGRAN4): on, 52_bit, off
> hw_prop_TGRAN4_2 (ID_AA64MMFR0.TGRAN4_2): tgran4, off, on, 52_bit
> hw_prop_TGRAN64 (ID_AA64MMFR0.TGRAN64): on, off
> hw_prop_TGRAN64_2 (ID_AA64MMFR0.TGRAN64_2): tgran64, off, on
> hw_prop_VARANGE (ID_AA64MMFR2.VARANGE): 48, 52
> hw_prop_VMIDBITS (ID_AA64MMFR1.VMIDBITS): 8, 16
>
> hw_prop_WRPs (ID_AA64DFR0.WRPS): u64
> hw_prop_IMInline (CTR_EL0.IMINLINE): u64
> hw_prop_IDC (CTR_EL0.IDC): u64
> hw_prop_DMInline (CTR_EL0.DMINLINE): u64
> hw_prop_DZP (DCZID_EL0.DZP): u64
> hw_prop_ERG (CTR_EL0.ERG): u64
> hw_prop_CTX_CMPs (ID_AA64DFR0.CTX_CMPS): u64
> hw_prop_CWG (CTR_EL0.CWG): u64
> hw_prop_DIC (CTR_EL0.DIC): u64
> hw_prop_ASIDBITS (ID_AA64MMFR0.ASIDBITS): 8, 16
> hw_prop_BRPS (ID_AA64DFR0.BRPS): u64
> hw_prop_BS (DCZID_EL0.BS): u64
Thanks

Eric

