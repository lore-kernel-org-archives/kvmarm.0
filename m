Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDC38C14;
	Mon,  2 Oct 2023 09:45:30 +0000 (UTC)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-533c4d20b33so6429859a12.0;
        Mon, 02 Oct 2023 02:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696239929; x=1696844729; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KGsTzw39DzKGKK/TLMQfTsY/wGdV95nt+7dMAry0cG0=;
        b=FnGqw3PdF4B5pKCJBJbFwDpfaF+rWvis8GzmoZOOfZka8fkUhfNffsQK2LlkkpHuQX
         /ulDCBvKVuhzvBcXWO1APGS6tKUeE2P3J/L2Eoq3psDR/ObcYfdqb8V5Sp1PgU8OE1hm
         UMcjajYeJ3jDxD7/ry0v+7tA4HUbWCR5CqUrJm2KckMgNQY3ES0cioswMRK3oD3MFHRQ
         h31AJkRKPCC8c3Sd1RhbIt/9CcDJ0RCDxJ1GErSMenYJFOGSWqT3nT+k7Xzgv95W4sj7
         trptbrqAHKsq8MEk+wmoglU7z7lKE1ApIAcYCf7LbXCXW+3PSHsf0tibMO8WReOR0pJ7
         GYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696239929; x=1696844729;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KGsTzw39DzKGKK/TLMQfTsY/wGdV95nt+7dMAry0cG0=;
        b=cEgCE/iMmASK9KRJ0V+zwzuIg9/3Z8T22Hb4RvrD5HTd9Sr7iHOyfyaO0zhCu4vww0
         R9NPABClgmCzytZk2YY5XBIpU8PN86aX8xYBBj7lautG4mpUV5n8009UZCcRRo9cF+nx
         8XAFRv2BUATR+NGBKCwhd+EZKVZbji9BALCNllzI1F7Pair/N0GP7Z4PbYZBRDXjzIFQ
         JkuYGb4PO9URjE+MptA0Eck1CRT9FIZdECJ0wBG4hF+CtdYoM5GcfGHkIAkF1Z5JKK4O
         lmjfXgMhbycvqj3BMT9nfP5soSC9t9gcvveaKzoyC7ELJ6VrI2QZ8bxw0zYHb3d6aB2j
         92Gg==
X-Gm-Message-State: AOJu0YyxHdMm/eC/PxVz+4q8+IT6suMMZXgsQ9OmYu/5zf1S8sgbIx11
	mhyNgx26xl4yDfW6WRaSxiM=
X-Google-Smtp-Source: AGHT+IEri3HR4lSj1taxtrBzWim+6JEVtI8cMbP3DbQmlY0nMrCNR5dgGLZShhANdijkosfOGPcLww==
X-Received: by 2002:aa7:d1c3:0:b0:52f:a763:aab4 with SMTP id g3-20020aa7d1c3000000b0052fa763aab4mr10819115edp.5.1696239929016;
        Mon, 02 Oct 2023 02:45:29 -0700 (PDT)
Received: from [192.168.5.6] (PC-176-101-165-146.tvk-net.pl. [176.101.165.146])
        by smtp.gmail.com with ESMTPSA id y15-20020aa7cccf000000b0053691cacd95sm5334019edt.87.2023.10.02.02.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 02:45:28 -0700 (PDT)
Message-ID: <14e3a4d5-672c-413d-5003-734839674494@gmail.com>
Date: Mon, 2 Oct 2023 11:45:27 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC kvmtool 00/31] arm64: Support for Arm Confidential Compute
 Architecture
Content-Language: en-US
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, Quentin Perret <qperret@google.com>,
 Steven Price <steven.price@arm.com>, Thomas Huth <thuth@redhat.com>,
 Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-coco@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
From: Piotr Sawicki <piotr.sawickas@gmail.com>
In-Reply-To: <20230127113932.166089-1-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Suzuki

> This series is an initial version of the support for running VMs under the
> Arm Confidential Compute Architecture. The purpose of the series is to gather
> feedback on the proposed UABI changes for running Confidential VMs with KVM.
> More information on the Arm CCA and instructions for how to get, build and run
> the entire software stack is available here [0].
> 
> A new option, `--realm` is added to the the `run` command to mark the VM as a
> confidential compute VM. This version doesn't use the Guest private memory [1]
> support yet, instead uses normal anonymous/hugetlbfs backed memory. Our aim is
> to switch to the guest private memory for the Realm.
> 
> The host including the kernel and kvmtool, must not access any memory allocated
> to the protected IPA of the Realm.
> 
> The series adds the support for managing the lifecycle of the Realm, which includes:
>     * Configuration
>     * Creation of Realm (RD)
>     * Load initial memory images
>     * Creation of Realm Execution Contexts (RECs aka VCPUs)a
>     * Activation of the Realm.
> 
> Patches are split as follows :
> 
> Patches 1 and 2 are fixes to existing code.
> Patch 3 adds a new option --nocompat to disable compat warnings
> Patches 4 - 6 are some preparations for Realm specific changes.
> 
> The remaining patches adds Realm support and using the --realm option is
> enabled in patch 30.
> 
> The v1.0 of the Realm Management Monitor (RMM) specification doesn't support
> paging protected memory of a Realm. Thus all of the memory backing the RAM
> is locked by the VMM.
> 
> Since the IPA space of a Realm is split into Protected and Unprotected, with
> one alias of the other, the VMM doubles the IPA Size for a Realm VM.
> 
> The KVM support for Arm CCA is advertised with a new cap KVM_CAP_ARM_RME.
> A new "VM type" field is defined in the vm_type for CREATE_VM ioctl to indicate
> that a VM is "Realm". Once the VM is created, the life cycle of the Realm is
> managed via KVM_ENABLE_CAP of KVM_CAP_ARM_RME.
> 
> Command line options are also added to configure the Realm parameters.
> These include :
>   - Hash algorithm for measurements
>   - Realm personalisation value
>   - SVE vector Length (Optional feature in v1.0 RMM spec. Not yet supported
>     by the TF-RMM. coming soon).
> 
> Support for PMU and self-hosted debug (number of watchpoint/breakpoit registers)
> are not supported yet in the KVM/RMM implementation. This will be added soon.
> 
> The UABI doesn't support discovering the "supported" configuration values. In
> real world, the Realm configuration 'affects' the initial measurement of the
> Realms and which may be verified by a remote entity. Thus, the VMM is not at
> liberty to make choices for configurations based on the "host" capabilities.
> Instead, VMM should launch a Realm with the user requested parameters. If this
> cannot be satisfied, there is no point in running the Realm. We are happy to
> change this if there is interest.
> 
> Special actions are required to load the initial memory images (e.g, kernel,
> firmware, DTB, initrd) in to the Realm memory.
> 
> For VCPUs, we add a new feature KVM_ARM_VCPU_REC, which will be used to control
> the creation of the REC object (via KVM_ARM_VCPU_FINALIZE). This must be done
> after the initial register state of the VCPUs are set.
> RMM imposes an order in which the RECs are created. i.e., they must be created
> in the ascending order of the MPIDR. This is for now a responsibility of the
> VMM.
> 
> Once the Realm images are loaded, VCPUs created, Realm is activated before
> the first vCPU is run.
> 
> virtio for the Realms enforces VIRTIO_F_ACCESS_PLATFORM flag.
> 
> Also, added support for injecting SEA into the VM for unhandled MMIO.
> 

I wonder if there is a plan to develop a dedicated (stand-alone) tool 
that allows a realm developer to calculate Realm Initial Measurements 
for realms. I mean a tool that can be compiled and run on a Linux PC 
machine.

As you know, the remote attestation mechanism requires a verifier to be 
provisioned with reference values. In this case, a realm verifier should 
have access to the initial reference measurement (RIM) of a realm that 
is intended to be run on a remote Arm CCA platform.

The algorithm that measures the initial state of realms (RIM) is highly 
sensitive to the content of a realm memory and the order of RMI 
operations. This means that not only the content of populated realm 
memory matters but also the implementation of the host components (e.g. 
kvm, kvmtool/qemu).In the  of kvmtool-cca, the layout of memory and the 
content of DTB highly depend on the provided options (DTB is generated 
in run-time). Unfortunately, the content of DTB also depends on the 
linking order of object files (the order of DTB generation is imposed by 
__attribute__((constructor)) that is used to register devices). This 
complicates development of a separate tool for calculating RIM, as the 
tool would have to emulate all quirks of the kvmtool.

One of the solution of retrieving Realm Initial Measurements seems to be 
running the whole firmware/software (e.g. kvmtool/Linux host/TF-RMM) 
stack on the FVP emulator and gathering the RIM directly from the 
TF-RMM. This would require a realm developer to have access to the whole 
firmware/software stack and the emulator of the CCA platform.

The other solution would require the implementation of a dedicated tool. 
For instance, a sensible approach could be to extend the functionality 
of kvmtool.

Is Arm going to develop a dedicated, stand-alone tool for calculating RIMs?

What is the recommended way of retrieving/calculating RIMs for realms?

Kind regards,
Piotr Sawicki
