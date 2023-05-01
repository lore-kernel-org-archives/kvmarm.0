Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C786220E2
	for <kvmarm@lists.linux.dev>; Mon,  1 May 2023 12:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682942983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bTR4qmPC5jiGnWXmXgq6yKiRVCe+WmrIqwmx0autYgo=;
	b=bsluVUObqxT1zKjvG130tFnWVAK6tqEMUD1kKHGRhB1J9BkT3S4fhx52G0q6qUGWpPomaw
	k461r8yxHnrgce/01RiGr5TFUjB4s08etJF7+ci0SdVWgGjc4ZBwvLqdOCQSjr7Cv158HY
	xLc7ubLd6/9M+C8MZWJpMkxqeJR3LIA=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-E2V12aIZOg6r0JIHj7qsaA-1; Mon, 01 May 2023 08:09:42 -0400
X-MC-Unique: E2V12aIZOg6r0JIHj7qsaA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1a687e3de0aso2675895ad.1
        for <kvmarm@lists.linux.dev>; Mon, 01 May 2023 05:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682942981; x=1685534981;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bTR4qmPC5jiGnWXmXgq6yKiRVCe+WmrIqwmx0autYgo=;
        b=KQI1Cbr4IQuYlTUoHHhEi1B1UuL0fTIgbccOfkTb+ESAspKII/WSzEH+UNitNQdp1l
         5WMnHUncpNtftkWLTeXXKYP6iyPmjh/hn61JdtyLL44FeVGWEgA1HiKBx4ZvQ89ydzjX
         zMO96DJuAEAIOOST8dXezOrrJq1nkrQg36WMtORqZgGcj//YtPClxA1vIu1KtuzXWxcL
         TI0UoqSSGCHJYmKeU7uopE6pkL3th7YzZ/IrpwaoNNyMZTBIVOeZ9SCVNugyDLtddULg
         vcv9p377I2Oa+LSbT5nQ9qF5afJjXFx2mPgdNH1TQPQr8FU8CBM2Ic+ReWT2JFVYwHL3
         C9gg==
X-Gm-Message-State: AC+VfDzsLOTCzN2X1NwIg1EzLchCdVI9dYm5hqzO31e5igi2SVZksXeX
	LG2WgTV5/oeLGxUb9aBNRukmQ4FNeZQqvgNvATLPcLe85aeLBBMWncxh8qkpU67r6+9LKs9k+1F
	53pzgA1Gs09UsMwhl
X-Received: by 2002:a17:902:f688:b0:1a6:e00b:c3e5 with SMTP id l8-20020a170902f68800b001a6e00bc3e5mr16641235plg.4.1682942981487;
        Mon, 01 May 2023 05:09:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5lgXligMC/Sba2Qe5cV0d9gKgs5mH8kzYP8On4TjijSdIh8F+VMP7gbuBz3HG8fzYT5hgL6Q==
X-Received: by 2002:a17:902:f688:b0:1a6:e00b:c3e5 with SMTP id l8-20020a170902f68800b001a6e00bc3e5mr16641200plg.4.1682942981065;
        Mon, 01 May 2023 05:09:41 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902e80d00b0019719f752c5sm7487498plg.59.2023.05.01.05.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:09:40 -0700 (PDT)
Message-ID: <b6e3bc3f-d409-00ae-df0f-4bcea9ec0330@redhat.com>
Date: Mon, 1 May 2023 20:09:36 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 00/29] EFI and ACPI support for arm64
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Nikos,

When I test this series by simply run ./run_tests.sh, some migration 
test will hang up forever, like the `its-migration` test.

After have a quick look, when do the migration test, the guest can't be 
migrated due to:

{"return": {"blocked-reasons": ["The qcow format used by node 
'#block389' does not support live migration", "The vvfat (rw) format 
used by node '#block085' does not support live migration"]}}

Although the guest will be timeout, but the script itself will not be 
timeout. The infinite loop happened at here:

// script/arch-run.bash
   151         # Wait for the migration to complete
   152         migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
   153         while ! grep -q '"completed"' <<<"$migstatus" ; do
   154                 sleep 1
   155                 migstatus=`qmp ${qmp1} '"query-migrate"' | grep 
return`
   156                 if grep -q '"failed"' <<<"$migstatus" ; then
   157                         echo "ERROR: Migration failed." >&2
   158                         qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
   159                         qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
   160                         return 2
   161                 fi
   162         done

Since the "query-migrate" here will never get "completed" or "failed", 
so it will never exit.

Have you ever meet this problem?

Thanks,
Shaoqin

On 4/28/23 20:03, Nikos Nikoleris wrote:
> Hello,
> 
> This series adds initial support for building arm64 tests as EFI
> apps and running them under QEMU. Much like x86_64, we import external
> dependencies from gnu-efi and adapt them to work with types and other
> assumptions from kvm-unit-tests. In addition, this series adds support
> for enumerating parts of the system using ACPI.
> 
> The first set of patches, moves the existing ACPI code to the common
> lib path. Then, it extends definitions and functions to allow for more
> robust discovery of ACPI tables. We add support for setting up the PSCI
> conduit, discovering the UART, timers, GIC and cpus via ACPI. The code
> retains existing behavior and gives priority to discovery through DT
> when one has been provided.
> 
> In the second set of patches, we add support for getting the command
> line from the EFI shell. This is a requirement for many of the
> existing arm64 tests.
> 
> In the third set of patches, we import code from gnu-efi, make minor
> changes and add an alternative setup sequence from arm64 systems that
> boot through EFI. Finally, we add support in the build system and a
> run script which is used to run an EFI app.
> 
> After this set of patches one can build arm64 EFI tests:
> 
> $> ./configure --enable-efi
> $> make
> 
> And use the run script to run an EFI tests:
> 
> $> ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"
> 
> Or all tests:
> 
> $> ./run_tests.sh
> 
> There are a few items that this series does not address but they would
> be useful to have:
>   - Support for booting the system from EL2. Currently, we assume that a
>     test starts EL1. This will be required to run EFI tests on sytems
>     that implement EL2.
>   - Support for reading environment variables and populating __envp.
>   - Support for discovering the PCI subsystem using ACPI.
>   - Get rid of other assumptions (e.g., vmalloc area) that don't hold on
>     real HW.
>   - Various fixes related to cache maintaince to better support turn the
>     MMU off.
>   - Switch to a new stack and avoid relying on the one provided by EFI.
> 
> git branch: https://github.com/relokin/kvm-unit-tests/pull/new/target-efi-upstream-v5
> 
> v4: https://lore.kernel.org/kvmarm/20230213101759.2577077-1-nikos.nikoleris@arm.com/
> v3: https://lore.kernel.org/all/20220630100324.3153655-1-nikos.nikoleris@arm.com/
> v2: https://lore.kernel.org/kvm/20220506205605.359830-1-nikos.nikoleris@arm.com/
> 
> Changes in v5:
>   - Minor style changes (thanks Shaoqin).
>   - Avoid including lib/acpi.o to cflatobjs twice (thanks Drew).
>   - Increase NR_INITIAL_MEM_REGIONS to avoid overflows and add check when
>     we run out of space (thanks Shaoqin).
> 
> Changes in v4:
>   - Removed patch that reworks cache maintenance when turning the MMU
>     off. This is not strictly required for EFI tests running with tcg and
>     will be addressed in a separate series by Alex.
>   - Fix compilation for arm (Alex).
>   - Convert ACPI tables to Linux style (Alex).
> 
> Changes in v3:
>   - Addressed feedback from Drew, Alex and Ricardo. Many thanks for the reviews!
>   - Added support for discovering the GIC through ACPI
>   - Added a missing header file (<elf.h>)
>   - Added support for correctly parsing the outcome of tests (./run_tests)
> 
> Thanks,
> 
> Nikos
> 
> Alexandru Elisei (2):
>    lib/acpi: Convert table names to Linux style
>    lib: arm: Print test exit status
> 
> Andrew Jones (2):
>    arm/arm64: Rename etext to _etext
>    arm64: Add a new type of memory type flag MR_F_RESERVED
> 
> Nikos Nikoleris (25):
>    lib: Move acpi header and implementation to lib
>    x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
>    lib: Apply Lindent to acpi.{c,h}
>    lib: Fix style for acpi.{c,h}
>    x86: Avoid references to fields of ACPI tables
>    lib/acpi: Ensure all struct definition for ACPI tables are packed
>    lib/acpi: Add support for the XSDT table
>    lib/acpi: Extend the definition of the FADT table
>    devicetree: Check that fdt is not NULL in dt_available()
>    arm64: Add support for setting up the PSCI conduit through ACPI
>    arm64: Add support for discovering the UART through ACPI
>    arm64: Add support for timer initialization through ACPI
>    arm64: Add support for cpu initialization through ACPI
>    arm64: Add support for gic initialization through ACPI
>    lib/printf: Support for precision modifier in printf
>    lib/printf: Add support for printing wide strings
>    lib/efi: Add support for getting the cmdline
>    lib: Avoid ms_abi for calls related to EFI on arm64
>    arm64: Add a setup sequence for systems that boot through EFI
>    arm64: Copy code from GNU-EFI
>    arm64: Change GNU-EFI imported code to use defined types
>    arm64: Use code from the gnu-efi when booting with EFI
>    lib: Avoid external dependency in libelf
>    arm64: Add support for efi in Makefile
>    arm64: Add an efi/run script
> 
>   scripts/runtime.bash        |  13 +-
>   arm/efi/run                 |  61 ++++++++
>   arm/run                     |  14 +-
>   configure                   |  17 +-
>   Makefile                    |   4 -
>   arm/Makefile.arm            |   6 +
>   arm/Makefile.arm64          |  22 ++-
>   arm/Makefile.common         |  47 ++++--
>   x86/Makefile.common         |   2 +-
>   x86/Makefile.x86_64         |   4 +
>   lib/linux/efi.h             |  25 +++
>   lib/arm/asm/setup.h         |   9 ++
>   lib/arm/asm/timer.h         |   2 +
>   lib/x86/asm/setup.h         |   2 +-
>   lib/acpi.h                  | 301 ++++++++++++++++++++++++++++++++++++
>   lib/argv.h                  |   1 +
>   lib/elf.h                   |  57 +++++++
>   lib/libcflat.h              |   1 +
>   lib/x86/acpi.h              | 112 --------------
>   lib/acpi.c                  | 129 ++++++++++++++++
>   lib/argv.c                  |   2 +-
>   lib/arm/gic.c               | 139 ++++++++++++++++-
>   lib/arm/io.c                |  41 ++++-
>   lib/arm/mmu.c               |   4 +
>   lib/arm/psci.c              |  37 ++++-
>   lib/arm/setup.c             | 269 ++++++++++++++++++++++++++------
>   lib/arm/timer.c             |  92 +++++++++++
>   lib/devicetree.c            |   2 +-
>   lib/efi.c                   | 102 ++++++++++++
>   lib/printf.c                | 194 +++++++++++++++++++++--
>   lib/x86/acpi.c              |  82 ----------
>   lib/x86/setup.c             |   2 +-
>   arm/efi/elf_aarch64_efi.lds |  63 ++++++++
>   arm/flat.lds                |   2 +-
>   arm/cstart.S                |   1 +
>   arm/cstart64.S              |   7 +
>   arm/efi/crt0-efi-aarch64.S  | 141 +++++++++++++++++
>   arm/dummy.c                 |  12 ++
>   arm/efi/reloc_aarch64.c     |  94 +++++++++++
>   arm/micro-bench.c           |   4 +-
>   arm/timer.c                 |  10 +-
>   x86/s3.c                    |  21 +--
>   x86/vmexit.c                |   4 +-
>   43 files changed, 1831 insertions(+), 323 deletions(-)
>   create mode 100755 arm/efi/run
>   create mode 100644 lib/acpi.h
>   create mode 100644 lib/elf.h
>   delete mode 100644 lib/x86/acpi.h
>   create mode 100644 lib/acpi.c
>   create mode 100644 lib/arm/timer.c
>   delete mode 100644 lib/x86/acpi.c
>   create mode 100644 arm/efi/elf_aarch64_efi.lds
>   create mode 100644 arm/efi/crt0-efi-aarch64.S
>   create mode 100644 arm/dummy.c
>   create mode 100644 arm/efi/reloc_aarch64.c
> 

-- 
Shaoqin

