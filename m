Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F70B30C148
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 04:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786423489; cv=none; b=Zdr8ur/Y4qJf0YaHJNSwXVMra8bn+bV4Yd9iIaKbmLkSc6jQC2uzcJ4/c2lofNJxrSUlj+hYf97epCePncscOPVSrBY/UE4aIvbGs+Y0NrtYaISotEo0NutmdU+DovH139CEDmOj0jcqz2SYlZEd9nWQChdUiYPTA4I2CRdZhXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786423489; c=relaxed/simple;
	bh=ILGF2Xb7HBRkYzwsMFrZCzDKxAZ9azjM/zJeEIVChmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nQ5UXZ2NC2GZrnwQUhyr9mQMAosRmq4Nn2Edvi8vxFmej46kVkUKo+eO2CPqgohNfA/c/EraooHyPXroOG3x7y0z4ukSzz66mdibLTiBi/9+23zVB+hU5OG/V9+358rwFVpfTAUinqe5acq7rRtuEoT12zHskMlH/tkALW8NtWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L0lu4UiX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L0lu4UiX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786423486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A7cCCND3yrSYhonnYSon2tUK602WWKbmDbjjTmzhQ+4=;
	b=L0lu4UiXeFR7USseUkgg7eKnMncZqgp2FbsJgV7y9ZAPETtDPvNVTXhynx+owSh/EyJoFL
	ptt/dUVpCU+oZlsXMkil6YvnRb+UsZSVPiU1i+bhxMRJEFHUrgqc/NMnwn5PvyD2FLltBr
	JwoIw/Y+X6pgfXlkTfioJ3MhHAI54uU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-TpMfjQr0OzaPRLorGCcFfg-1; Tue, 11 Aug 2026 00:44:44 -0400
X-MC-Unique: TpMfjQr0OzaPRLorGCcFfg-1
X-Mimecast-MFC-AGG-ID: TpMfjQr0OzaPRLorGCcFfg_1786423484
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e667368f0so5118382a91.2
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 21:44:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786423484; x=1787028284;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A7cCCND3yrSYhonnYSon2tUK602WWKbmDbjjTmzhQ+4=;
        b=djyQItLeG4S5YPwbDFmMz1FqUNS4//Ndu0nFZVrLp9Tj8EQz6NDt9uAYrw1vRdFLub
         5cV7SmOHX7Ll/Ub3JadcbsekUhTuwh8/s5yBtekdyR/Dh1GPtmMzks+SbBoX5VWH8Iak
         GuxIK8IDFFNH+PKf3xv4Twoif6sN9pbXcnRh0Z1diSscxdWJQgC7FJfw3KRFp5aTBPtC
         ogkoumFcI4idT5oSsSQ1/VT9H8j8x0RcSoWS8eWNsmQH83GUfZ1EIXH7SkrNH6lWpmb2
         OFtdqeqNEcOtlfjBi26g47kpNtEuBOlBkr3/wYujUrT43mwhEx7TBc14k8R8m5Ryucta
         TzTg==
X-Forwarded-Encrypted: i=1; AHgh+RqlsCIdqB2n/hcScjWC6E7gjeasW5p0naOax5JMIIiuibDFsWoSsXFUNn312fqVPmOc9ZR3JvU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwW66IV70n9IrdhsN3H8Z6PMytn3wYjRKS4Nvbf5MVJ9I15+oVy
	m11fvFgqfTvBKpp7AsPORRohJ+zVwZwZAW1ugwtyBhNhWtfRE4IMReUQ0dr7qfJKXCx01C5vr/1
	lj0i3RO5PKPU2Pc3awaXfJm1vmHeVh0gjW6dA/MHY9eqEP+0Q2mWKpRUPag==
X-Gm-Gg: AR+sD12GyyNjfUcPmi06tyO0noub/Jp2VcUcluG73K93C0jtiZ/TzmzySUfnxtMuaFT
	OeIL69Ymu3bHMGECh0Gx6GjUgNiC7zHj87u/CbFUvBivjaVuWv37q0hUPjtI86shRWtPpqTHnyO
	o4PrqRMh4igNfw5X/zRUIEv720WALKXN674Lxcbpt7mVq1En++bFa3HnCCTQEzNowPZMIZSDWDh
	xEMWro0lwSpy6bkimFN9LkBoeZmBv91ofLOYjDxwxuibTNg40tMWbYyRaVxTh3ERCdwj3W/BMjc
	oXi7mXRpFrNCRQ4cca1TOw83qx2JqCJARMXeh2m5me93SBZGwyRCsIXnzlHGMgNgFdzigR2MXQm
	Oi7i2s9VXTRGQ7S8JRGrmbHxaTiow7q0enPYiKvgBWp4=
X-Received: by 2002:a17:90b:5608:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-392ec184a5amr735460a91.0.1786423483655;
        Mon, 10 Aug 2026 21:44:43 -0700 (PDT)
X-Received: by 2002:a17:90b:5608:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-392ec184a5amr735414a91.0.1786423483127;
        Mon, 10 Aug 2026 21:44:43 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392e588aad2sm233317a91.4.2026.08.10.21.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 21:44:42 -0700 (PDT)
Message-ID: <d0ffbcb5-0cca-4d1e-9788-6b430345fa9b@redhat.com>
Date: Tue, 11 Aug 2026 14:44:30 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/45] arm64: Support for Arm CCA in KVM
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <42170467-fe36-4382-867f-49bdc6a7bc9a@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <42170467-fe36-4382-867f-49bdc6a7bc9a@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8agwkc_e7FnkEXegjirym5wqvIbZwSbOMHBPCxmX1Hs_1786423484
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/26 8:05 AM, Suzuki K Poulose wrote:

[...]

> 
> Here is a cleaned up version, rebased on to Will's kvmtool master
> branch:
> 
> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/kvm-v16
> 
> (This works with the v15 of the KVM series too)
> Build on top of Fuad's Guest memfd support patches.
> 

With the following combination, I'm able boot up the realm guest.

   tf-rmm:   https://git.trustedfirmware.org/TF-RMM/tf-rmm.git            (branch: topics/rmm-v2.0-poc_2)
   tf-a:     https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git  (branch: master)
   host:     https://git.gitlab.arm.com/linux-arm/linux-cca.git           (branch: cca-host/v16)
   kvmtool:  https://gitlab.arm.com/linux-arm/kvmtool-cca                 (branch: cca/kvm-v16)

However, the guest can't boot up and become stuck in SMC_RSI_IPA_STATE_SET request,
which can't completed by the host.

   tf-rmm:   https://git.trustedfirmware.org/TF-RMM/tf-rmm.git            (branch: topics/rmm-v2.0-poc_3)

(1) Login the emulated host

machine$ ssh -o StrictHostKeyChecking=no root@10.26.1.240

(2) Start realm guest using kvmtool

root@host:~# lkvm run --realm -c 1 -m 256                   \
              -k /mnt/linux/arch/arm64/boot/Image            \
              -i /mnt/buildroot/output/images/rootfs.cpio.xz \
              -p earlycon=uart,mmio,0x101000000
                  :
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x000f0510]
[    0.000000] Linux version 7.2.0-rc5-gavin-gf5098b6bae76 (gshan@nvidia-grace-hopper-01.khw.eng.bos2.dc.redhat.com) (gcc (GCC) 14.3.1 20251022 (Red Hat 14.3.1-4), GNU ld version 2.41-65.el10) #47 SMP PREEMPT Mon Jul 27 02:29:03 EDT 2026
[    0.000000] KASLR enabled
[    0.000000] Machine model: linux,dummy-virt
[    0.000000] earlycon: uart0 at MMIO 0x0000000101000000 (options '')
[    0.000000] printk: legacy bootconsole [uart0] enabled
[    0.000000] efi: UEFI not found.
[    0.000000] OF: reserved mem: Reserved memory: No reserved-memory node in the DT
[    0.000000] NUMA: Faking a node at [mem 0x0000000080000000-0x000000008fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x8ff76dc0-0x8ff7ac7f]
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000] psci: SMC Calling Convention v1.2
[    0.000000] RME: Using RSI version 1.0
<... no more output from the guest ...>


(3) The output from host's serial console

SMC_RMI_REALM_CREATE              12a4c7000 12a4c6000 > RMI_INCOMPLETE 0 24 0 0
       SMC_RMI_OP_MEM_DONATE       0 1002c7098 9 > RMI_INCOMPLETE 9 0 0 0
       SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 0 0
SMC_RMI_RTT_UNPROT_UNMAP          12a4c7000 18f85c000 18fe00000 0 0 > RMI_ERROR_RTT 2 0 0 0 0
SMC_RMI_RTT_UNPROT_UNMAP          12a4c7000 18fe00000 18fe10000 0 0 > RMI_ERROR_RTT 2 0 0 0 0
SMC_RMI_RTT_UNPROT_UNMAP          12a4c7000 18fe00000 18fe10000 0 0 > RMI_ERROR_RTT 2 0 0 0 0
SMC_RMI_REC_CREATE                12a4c7000 12a392000 12a391000 > RMI_INCOMPLETE 0 40 0 0
       SMC_RMI_OP_MEM_DONATE       0 106406098 10 > RMI_INCOMPLETE 10 0 0 0
       SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 0 0
SMC_RMI_REALM_ACTIVATE            12a4c7000 > RMI_SUCCESS
Unhandled write S2_0_C0_C2_2
SMC_RMI_RTT_DATA_MAP              12a4c7000 8ffb4000 8ffb5000 1 129f1d004 > RMI_INCOMPLETE 0 0 0 1
       SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 8ffb5000 0
PSCI_84000000                     0 0 0 0 0 0 0 > 10001 0 0 0
PSCI_84000006                     0 0 0 0 0 0 0 > ffffffffffffffff 0 0 0
PSCI_8400000a                     80000000 0 0 0 0 0 0 > 0 0 0 0
SMC_80000000                      0 0 0 0 0 0 0 > 10002 0 0 0
SMC_84000050                      1 0 0 ffffacd67d1e8000 ffffacd67d124000 0 0 > ffffffffffffffff 0 0 0
SMC_80000001                      80000002 ffff 0 ffffacd67d1e8000 ffffacd67d124000 ffffacd67cd5d000 ffffacd67cd5dd38 > ffffffffffffffff 0 0 0
PSCI_8400000a                     c4000001 0 0 0 0 0 0 > 0 0 0 0
PSCI_8400000a                     c4000012 0 0 0 0 0 0 > ffffffffffffffff 0 0 0
PSCI_8400000a                     c4000015 0 0 0 0 0 0 > ffffffffffffffff 0 0 0
SMC_8600ff01                      ffffacd67cfc0740 10002 0 0 0 0 ffffacd67cfb3cc8 > ffffffffffffffff 0 0 0
SMC_RSI_VERSION                   10000 > RSI_SUCCESS 10000 10001
SMC_RSI_REALM_CONFIG              81385000 > RSI_SUCCESS
SMC_RSI_IPA_STATE_SET             80000000 90000000 1 0
SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 > RMI_ERROR_RTT 3
SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 > RMI_ERROR_RTT 3
SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 > RMI_ERROR_RTT 3
SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 > RMI_ERROR_RTT 3
SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 > RMI_ERROR_RTT 3
SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000 > RMI_ERROR_RTT 3
<... the last message repeats ...>

Thanks,
Gavin


