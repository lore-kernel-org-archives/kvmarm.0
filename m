Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41961A01C6
	for <kvmarm@lists.linux.dev>; Thu, 26 Mar 2026 00:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774486139; cv=none; b=WvR43RoGwXtZluWLLpxbfgeeEV9TitapNrq6Ttr4yQ7UcIMI/fcFjGSfjFiAkq2RwwPyvl8pSAcawjcIZ8lZs/vYaEBxpE0srIsTR87Hs8xVdXHUFOlYA3q4Lnkxd1OtYMF0NXHP7RH4xQu1nhjcgfRWQKg2hJ9nVIz+aJKGMjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774486139; c=relaxed/simple;
	bh=7kaLwUO0ndW82zmJFnv547UOGhGY2wLv2BFXA/LGN3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQ3jtSC+Q+0bF9D4RUqsx575/CN31BjJz6NvMLmVo6z2DpZ7C+Lls0KbmnzLsxZHaM0wZTUCpOydkf2MRZ+Tacgi/SQ5sKyLViOiymK/g+ZNElbdWeoB7luu2vIvvkzWZJvKTu7Cw+nOWnY8kVRVebdnIJ2/Bs7XA+o+S+kVPMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cT8wHjKR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cT8wHjKR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774486136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ls8wjcbdyWhGqHWxekvGDwcUF0lyag9U62sJrXk3qX0=;
	b=cT8wHjKREU6PK1bYBhqHu6yUwu5hadVRWAC78YBS7GFApWQWiOD48XI9lyih6ueyouzbxJ
	AYeEQdLSHK2TuuKn5KVaWxXQcRAbyLBRAYlnlGP+toF+JoPKijhfMmwWQOADU7k3leG4aE
	Sc0XygEhzdfzROyLN9okgsv4CLyOECY=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-Sg7Ur2fgMYakR8W4ZI2SVA-1; Wed, 25 Mar 2026 20:48:55 -0400
X-MC-Unique: Sg7Ur2fgMYakR8W4ZI2SVA-1
X-Mimecast-MFC-AGG-ID: Sg7Ur2fgMYakR8W4ZI2SVA_1774486134
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2aeb90532f6so4753185ad.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 17:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774486134; x=1775090934;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ls8wjcbdyWhGqHWxekvGDwcUF0lyag9U62sJrXk3qX0=;
        b=KFtF1pnX/E8oQRFjgYwvNWRQToCuAJ2sdrpn4sLDdd5VGtA+Tr4UrRXbYTpYI0QneQ
         fcRfhDdf6QQ2bmWHeL4/LZq3EdSkzX2kDptOJHsJ5fp79Sc8iNGl0CuXXLTrGyrzKPh0
         KH20Itqz6UQzfLOKcOJcucIbLoWQcO3FuL/RrjmDkUEtc6l+RxSzoula+QuaOOreXCud
         d4JF55TMfU9QHqlbAzFkchdCM5RmmAE+sDq7PQ8xHNeekbvSw8CDDDmRIzrswi5qsAe/
         G+U1rCfqCRGk9AY2n55sMCd0v4XX1HiROzZ4lZ0Z8tRu00SdxTGziATf4n0GoSEzD1j8
         KxgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIOIzOhNGWpECYJvf3uB8x6qm47/KhSs7jWu1P7zYOA+8B0cXIv0ABoty3Q2xYNC0r3PLlj50=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHzKbYZ4dMIgjv+puG2+ahtcMXtyOubq71NMFLdtCfk1ppYRzC
	0H2uavlbJvZSbhYMZC6+opp8X623NU6ievw/pL3mjI+n9Mr8mN2Svqejlo+YyIN56V1VWycxuqC
	rpa4e8jP0w/LRH2mPPs6yW23q1zJJ9+PZxeM++uu2tQ3mNmmt42iL8R5eCQ==
X-Gm-Gg: ATEYQzxIXiBF24EpyBIE8mFVsl7++SstxCLotD370yUDJO0enj2v5pUyqBbujiseYkg
	b+/jtSprDpHgtj0fDfhxrQE3VfHy4Z9b/1mzYAuU0We9Y5on4GHLY9xrTLnYoZt9V7Ua1EOc8a6
	EhdJeOwvMSxNH6/7QSC5MmH50CHMHcAfIosBVovR8pNWDkWU7z6Ywmo9FAMie17RK+v8MTmQ/8W
	kuV3eZPuR/v2jCF2fPLpHua09D6xC2JYjZ6xYfAw7p2u3K6/p0s/Dv1iGIjolgQsazcQHJzTIvT
	cq2J6ytQLLkjuYKzFM8HiDILsbDVW/6OttCA9G19Wh96aA5/D3JU0pY5fF9xy9O6KBbT8LuiJqV
	VaxmmopCB2Id/aDBqx+3DLG+HBZBdwFJAWoadz+SAVoK1qGAIUBaJMPqoNdL9Pl5I
X-Received: by 2002:a17:902:da91:b0:2b0:6e4a:1c1c with SMTP id d9443c01a7336-2b0b0a1554dmr62523375ad.19.1774486134089;
        Wed, 25 Mar 2026 17:48:54 -0700 (PDT)
X-Received: by 2002:a17:902:da91:b0:2b0:6e4a:1c1c with SMTP id d9443c01a7336-2b0b0a1554dmr62522885ad.19.1774486133511;
        Wed, 25 Mar 2026 17:48:53 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc76b6casm11221805ad.16.2026.03.25.17.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 17:48:52 -0700 (PDT)
Message-ID: <807b844c-32f6-4094-8c24-15d7eb1d3638@redhat.com>
Date: Thu, 26 Mar 2026 10:48:41 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <abyAbPIkDn2bGZwd@p14s> <37bc1222-6fc7-48f0-94d3-6eaac420aa55@arm.com>
 <0b7121e7-3c74-4303-a200-01d2b7c535ce@redhat.com>
 <9247d9ea-64b4-4e8e-81f8-3c8e00750acf@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <9247d9ea-64b4-4e8e-81f8-3c8e00750acf@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DzL6lKFrNdRkBf2ieRIwjXyw2cTjpUnoYybgIjH4ZWg_1774486134
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Suzuki,

On 3/25/26 8:16 PM, Suzuki K Poulose wrote:
> On 25/03/2026 06:37, Gavin Shan wrote:
>> On 3/21/26 2:45 AM, Steven Price wrote:

[...]

>>
>> In upstream TF-A repository [1], I don't see the config option 'RMM_V1_COMPAT'.
>> would it be something else?
>>
>> [1] git@github.com:ARM-software/arm-trusted-firmware.git    (branch: master)
>>
> 
> suzuki@ewhatever:trusted-firmware-a$ git grep RMM_V1_COMPAT
> Makefile:       RMM_V1_COMPAT \
> Makefile:       RMM_V1_COMPAT \
> docs/getting_started/build-options.rst:-  ``RMM_V1_COMPAT``: Boolean flag to enable support for RMM v1.x compatibility
> include/services/rmmd_svc.h:#if RMM_V1_COMPAT
> include/services/rmmd_svc.h:#endif /* RMM_V1_COMPAT */
> make_helpers/defaults.mk:RMM_V1_COMPAT                  := 1
> services/std_svc/rmmd/rmmd_main.c:#if RMM_V1_COMPAT
> services/std_svc/rmmd/rmmd_main.c:#if RMM_V1_COMPAT
> services/std_svc/rmmd/rmmd_main.c:#if !RMM_V1_COMPAT
> services/std_svc/rmmd/rmmd_main.c:#if RMM_V1_COMPAT
> services/std_svc/rmmd/rmmd_main.c:#if RMM_V1_COMPAT
> services/std_svc/rmmd/rmmd_main.c:#if RMM_V1_COMPAT
> services/std_svc/rmmd/rmmd_rmm_lfa.c:#if RMM_V1_COMPAT
> services/std_svc/rmmd/rmmd_rmm_lfa.c:#if RMM_V1_COMPAT
> services/std_svc/rmmd/rmmd_rmm_lfa.c:#if RMM_V1_COMPAT
> services/std_svc/rmmd/rmmd_rmm_lfa.c:#if RMM_V1_COMPAT
> suzuki@ewhatever:trusted-firmware-a$ git log --oneline -1
> 8dae0862c (HEAD, origin/master, origin/integration, origin/HEAD) Merge changes from topic "qti_lemans_evk" into integration
> suzuki@ewhatever:trusted-firmware-a$ git remote get-url origin
> https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git
> 

Thanks for the details. It turned out that I used the wrong TF-A repository. In
the proposed repository, I'm able to see the option 'RMM_V1_COMPAT' and the EL3-RMM
interface compatible issue disappears. However, there are more issues popped up.

I build everything manually where the host is emulated by QEMU instead of shrinkwrap
and FVP model. It's used to work well before. Maybe it's time to switch to shinkwrap
and FVP model since device assignment (DA) isn't supported by an emulated host
by QEMU and shrinkwrap and FVP model seems the only option. I need to learn how
to do that later.

There are two issues I can see with the following combinations. Details are provided
like below.

     QEMU:      https://git.qemu.org/git/qemu.git                            (branch: stable-9.2)
     TF-RMM:    https://git.trustedfirmware.org/TF-RMM/tf-rmm.git            (branch: topics/rmm-v2.0-poc)
     EDK2:      git@github.com:tianocore/edk2.git                            (tag:    edk2-stable202411)
     TF-A:      https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git  (branch: master)
     HOST:      https://git.gitlab.arm.com/linux-arm/linux-cca.git           (branch: cca-host/v13)
     BUILDROOT: https://github.com/buildroot/buildroot                       (branch: master)
     KVMTOOL:   https://gitlab.arm.com/linux-arm/kvmtool-cca                 (branch: cca/v11)
     GUEST:     https://github.com/torvalds/linux.git                        (branch: master)

(1) The emulated host is started by the following command lines.

     sudo /home/gshan/sandbox/cca/host/qemu/build/qemu-system-aarch64                  \
     -M virt,virtualization=on,secure=on,gic-version=3,acpi=off                        \
     -cpu max,x-rme=on -m 8G -smp 8                                                    \
     -serial mon:stdio -monitor none -nographic -nodefaults                            \
     -bios /home/gshan/sandbox/cca/host/tf-a/flash.bin                                 \
     -kernel /home/gshan/sandbox/cca/host/linux/arch/arm64/boot/Image                  \
     -initrd /home/gshan/sandbox/cca/host/buildroot/output/images/rootfs.cpio.xz       \
     -device pcie-root-port,bus=pcie.0,chassis=1,id=pcie.1                             \
     -device pcie-root-port,bus=pcie.0,chassis=2,id=pcie.2                             \
     -device pcie-root-port,bus=pcie.0,chassis=3,id=pcie.3                             \
     -device pcie-root-port,bus=pcie.0,chassis=4,id=pcie.4                             \
     -device virtio-9p-device,fsdev=shr0,mount_tag=shr0                                \
     -fsdev local,security_model=none,path=/home/gshan/sandbox/cca/guest,id=shr0       \
     -netdev tap,id=tap1,script=/etc/qemu-ifup-gshan,downscript=/etc/qemu-ifdown-gshan \
     -device virtio-net-pci,bus=pcie.2,netdev=tap1,mac=b8:3f:d2:1d:3e:f1

(2) Issue-1: TF-RMM complains about the root complex list is invalid. This error is
     raised in TF-RMM::setup_root_complex_list() where the error code is still set to
     0 (SUCCESS) in this failing case. The TF-RMM initialization is terminated early,
     but TF-A still thinks the initialization has been completely done.

     INFO:    BL31: Initializing RMM
     INFO:    RMM init start.
     RMM EL3 compat memory reservation enabled.
     Dynamic VA pool base address: 0xc0000000
     Reserved 20 pages. Remaining: 3615 pages
     Reserve mem: 20 pages at PA: 0x401f2000 (alignment 0x1000)
     Static Low VA initialized. xlat tables allocated: 20 used: 7
     Reserved 514 pages. Remaining: 3101 pages
     Reserve mem: 514 pages at PA: 0x40206000 (alignment 0x1000)
     Dynamic Low VA initialized. xlat tables allocated: 514 used: 514
     Invalid: Root Complex list                                         <<<<< ERROR
     INFO:    RMM init end.

(3) Issue-2: The host kernel gets stuck in rmi_check_version() where SMC_RMI_VERSION
     is issued to TF-A, but it can't be forwarded to TF-RMM because its initialization
     isn't completely done (issue-1).

     [   37.438253] Unpacking initramfs...
     [   37.563460] kvm [1]: nv: 570 coarse grained trap handlers
     [   37.581139] kvm [1]: nv: 664 fine grained trap handlers
     <... system becomes stuck here ...>

So my workaround is to skip fetching root complex list from the EL3-RMM manifest data
in TF-RMM::setup_root_complex_list() since it's not provided for the qemu platform by
TF-A. With this workaround, the host can boot up into shell prompt and the guest can
be started by kvmtool.

     host$ uname -r
     7.0.0-rc1-gavin-gd62aa44b2590
     host$ lkvm run --realm -c 2 -m 256                   \
           -k /mnt/linux/arch/arm64/boot/Image            \
           -i /mnt/buildroot/output/images/rootfs.cpio.xz
           -p earlycon=uart,mmio,0x101000000
     Info: # lkvm run -k /mnt/linux/arch/arm64/boot/Image -m 256 -c 2 --name guest-163
     Info: Enabling Guest memfd for confidential guest
     Warning: The maximum recommended amount of VCPUs is 1
     [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x000f0510]
     [    0.000000] Linux version 7.0.0-rc2-gavin-g0031c06807cf (gshan@nvidia-grace-hopper-01.khw.eng.bos2.dc.redhat.com) (gcc (GCC) 14.3.1 20251022 (Red Hat 14.3.1-4), GNU ld version 2.41-64.el10) #2 SMP PREEMPT Wed Mar 25 20:28:05 EDT 2026
     [    0.000000] KASLR enabled
          :
     [  267.578060] Freeing initrd memory: 4728K
     [  267.921865] Warning: unable to open an initial console.
     [  270.327960] Freeing unused kernel memory: 1792K
     [  270.669368] Run /init as init process

Thanks,
Gavin

