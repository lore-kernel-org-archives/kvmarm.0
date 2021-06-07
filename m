Return-Path: <SRS0=60kf=LB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7C2C47082
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 22:13:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ECA4A61208
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 22:13:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECA4A61208
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72582402A9;
	Mon,  7 Jun 2021 18:13:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ptJVzLCW9Eo4; Mon,  7 Jun 2021 18:13:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B21564079A;
	Mon,  7 Jun 2021 18:13:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1113E4079A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 18:13:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X36jSs7Ku7J5 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jun 2021 18:13:07 -0400 (EDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com
 [209.85.208.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5C43402A9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 18:13:06 -0400 (EDT)
Received: by mail-lj1-f180.google.com with SMTP id c11so24297508ljd.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Jun 2021 15:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ofoN2n9wD0dgNk8OiPa/nD07kpzlkV/bFCxgo7deAmk=;
 b=d0lYkzsmvl6gUh9AAcK69MkrG+bGRLzskP5qLEPf8WSsFxhZ1CbKXU5YUyFiKaYNBg
 +AA+R2lQ5GPKI5mCCclNP7JpuvvxcvI7TYvZ7fAWQGmG3splLaRXZeTTFioYAfHBJZrv
 g+6AWfoF87Y0QIy18pxpb1JMnn2q8NSc6x1qeUUU6aAZk73B4vES5o6w5oEnvprWh3GL
 Nbxdx/SYfwO5DwvAJRLFM9FaTFH0rJk/awRqd3yG0qr/wo7qI+lE+S384VmSxjPmDemJ
 IAhZHf/i3MQtXFcTlWNabvwUUYIhwmk8UvgyjWqOcCryHEi0PSFziVzwtmuYQwmQGiYB
 dSIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ofoN2n9wD0dgNk8OiPa/nD07kpzlkV/bFCxgo7deAmk=;
 b=YvRZw2Fz1mASubqTgRumuV2+fr3dWY2VHLTrRWdWlkr8kp+dC8fpngxxGm+9R83Tld
 lwG4ecZQu07TTTXAD6GVmXF9UPz0ZtMwuzsMo7LFv5g7+z871cmNjVhFescs0EE53CRW
 FEGE+6tp9Lu+JukDZnRD1EOLOFVwiiZBRzijquiz+ZY7LwZYihmiVAz6sog/ZsPd6kTg
 1WYxtBuCgvl4XYt7E0aIsbL3boR/esImLDBy6pfnl8X8X5JJ8J/kAh+Y+A4Kcnvhxyyz
 u6025DJxs55Lygh6jUEbp/Bc6Wyy2u7cIIeXNEiFWhJIzEqa+Ekhz6jRRYT+XduD/vr6
 00Jw==
X-Gm-Message-State: AOAM532qmaQD/uwLP5qkfPabcapzHLEoRnfRV/TRN1LwRiJ5lCpejXL/
 3rMmMcB4LITXFtMcuKJL2tRu6ofbqDVdSFDVG96pSw==
X-Google-Smtp-Source: ABdhPJxl/WVWgCJ4qBjCXWD/JUEcu6cAXOAt9RQUSrwqg/SEoYLZ8MwXCWH1PkqjAIa/ycgLpyWTuGurvxTKELDV7oU=
X-Received: by 2002:a05:651c:10b9:: with SMTP id
 k25mr6560744ljn.256.1623103985122; 
 Mon, 07 Jun 2021 15:13:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-5-jingzhangos@google.com>
 <122adf1f-1cb8-8cc4-d52f-8e434ab6c95b@oracle.com>
In-Reply-To: <122adf1f-1cb8-8cc4-d52f-8e434ab6c95b@oracle.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 7 Jun 2021 17:12:52 -0500
Message-ID: <CAAdAUtipEraJZMXq1m8L-QRjn3Kyp6jR2yh9nsoUkn92gQnwuw@mail.gmail.com>
Subject: Re: [PATCH v7 4/4] KVM: selftests: Add selftest for KVM statistics
 data binary interface
To: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Jun 7, 2021 at 2:23 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 6/3/21 2:14 PM, Jing Zhang wrote:
> > Add selftest to check KVM stats descriptors validity.
> >
> > Reviewed-by: David Matlack <dmatlack@google.com>
> > Reviewed-by: Ricardo Koller <ricarkol@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >   tools/testing/selftests/kvm/.gitignore        |   1 +
> >   tools/testing/selftests/kvm/Makefile          |   3 +
> >   .../testing/selftests/kvm/include/kvm_util.h  |   3 +
> >   .../selftests/kvm/kvm_binary_stats_test.c     | 215 ++++++++++++++++++
> >   tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +
> >   5 files changed, 234 insertions(+)
> >   create mode 100644 tools/testing/selftests/kvm/kvm_binary_stats_test.c
> >
> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index bd83158e0e0b..d1c3ee7d3e41 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -43,3 +43,4 @@
> >   /memslot_modification_stress_test
> >   /set_memory_region_test
> >   /steal_time
> > +/kvm_binary_stats_test
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index e439d027939d..0cd46d6d1e15 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -76,6 +76,7 @@ TEST_GEN_PROGS_x86_64 += kvm_page_table_test
> >   TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
> >   TEST_GEN_PROGS_x86_64 += set_memory_region_test
> >   TEST_GEN_PROGS_x86_64 += steal_time
> > +TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
> >
> >   TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> >   TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
> > @@ -87,6 +88,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
> >   TEST_GEN_PROGS_aarch64 += kvm_page_table_test
> >   TEST_GEN_PROGS_aarch64 += set_memory_region_test
> >   TEST_GEN_PROGS_aarch64 += steal_time
> > +TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
> >
> >   TEST_GEN_PROGS_s390x = s390x/memop
> >   TEST_GEN_PROGS_s390x += s390x/resets
> > @@ -96,6 +98,7 @@ TEST_GEN_PROGS_s390x += dirty_log_test
> >   TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
> >   TEST_GEN_PROGS_s390x += kvm_page_table_test
> >   TEST_GEN_PROGS_s390x += set_memory_region_test
> > +TEST_GEN_PROGS_s390x += kvm_binary_stats_test
> >
> >   TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
> >   LIBKVM += $(LIBKVM_$(UNAME_M))
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index a8f022794ce3..96d15da3d72e 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -387,4 +387,7 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
> >   #define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
> >       __GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
> >
> > +int vm_get_stats_fd(struct kvm_vm *vm);
> > +int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
> > +
> >   #endif /* SELFTEST_KVM_UTIL_H */
> > diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > new file mode 100644
> > index 000000000000..081983110dc5
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > @@ -0,0 +1,215 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * kvm_binary_stats_test
> > + *
> > + * Copyright (C) 2021, Google LLC.
> > + *
> > + * Test the fd-based interface for KVM statistics.
> > + */
> > +
> > +#define _GNU_SOURCE /* for program_invocation_short_name */
> > +#include <fcntl.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <errno.h>
> > +
> > +#include "test_util.h"
> > +
> > +#include "kvm_util.h"
> > +#include "asm/kvm.h"
> > +#include "linux/kvm.h"
> > +
> > +void stats_test(int stats_fd, int size_stat)
> > +{
> > +     ssize_t ret;
> > +     int i;
> > +     size_t size_desc, size_data = 0;
> > +     struct kvm_stats_header header;
> > +     struct kvm_stats_desc *stats_desc, *pdesc;
> > +     void *stats_data;
> > +
> > +     /* Read kvm stats header */
> > +     ret = read(stats_fd, &header, sizeof(header));
> > +     TEST_ASSERT(ret == sizeof(header), "Read stats header");
> > +     size_desc = sizeof(*stats_desc) + header.name_size;
> > +
> > +     /* Check id string in header, that should start with "kvm" */
> > +     TEST_ASSERT(!strncmp(header.id, "kvm", 3) &&
> > +                     strlen(header.id) < KVM_STATS_ID_MAXLEN,
> > +                     "Invalid KVM stats type");
> > +
> > +     /* Sanity check for other fields in header */
> > +     if (header.count == 0) {
> > +             printf("No KVM stats defined!");
> > +             return;
> > +     }
> > +     /* Check overlap */
> > +     TEST_ASSERT(header.desc_offset > 0 && header.data_offset > 0
> > +                     && header.desc_offset >= sizeof(header)
> > +                     && header.data_offset >= sizeof(header),
> > +                     "Invalid offset fields in header");
> > +     TEST_ASSERT(header.desc_offset > header.data_offset
> > +                     || (header.desc_offset + size_desc * header.count <=
> > +                             header.data_offset),
> > +                     "Descriptor block is overlapped with data block");
> > +
> > +     /* Allocate memory for stats descriptors */
> > +     stats_desc = calloc(header.count, size_desc);
> > +     TEST_ASSERT(stats_desc, "Allocate memory for stats descriptors");
> > +     /* Read kvm stats descriptors */
> > +     ret = pread(stats_fd, stats_desc,
> > +                     size_desc * header.count, header.desc_offset);
> > +     TEST_ASSERT(ret == size_desc * header.count,
> > +                     "Read KVM stats descriptors");
> > +
> > +     /* Sanity check for fields in descriptors */
> > +     for (i = 0; i < header.count; ++i) {
> > +             pdesc = (void *)stats_desc + i * size_desc;
> > +             /* Check type,unit,base boundaries */
> > +             TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK)
> > +                             <= KVM_STATS_TYPE_MAX, "Unknown KVM stats type");
> > +             TEST_ASSERT((pdesc->flags & KVM_STATS_UNIT_MASK)
> > +                             <= KVM_STATS_UNIT_MAX, "Unknown KVM stats unit");
> > +             TEST_ASSERT((pdesc->flags & KVM_STATS_BASE_MASK)
> > +                             <= KVM_STATS_BASE_MAX, "Unknown KVM stats base");
> > +             /* Check exponent for stats unit
> > +              * Exponent for counter should be greater than or equal to 0
> > +              * Exponent for unit bytes should be greater than or equal to 0
> > +              * Exponent for unit seconds should be less than or equal to 0
> > +              * Exponent for unit clock cycles should be greater than or
> > +              * equal to 0
> > +              */
> > +             switch (pdesc->flags & KVM_STATS_UNIT_MASK) {
> > +             case KVM_STATS_UNIT_NONE:
> > +             case KVM_STATS_UNIT_BYTES:
> > +             case KVM_STATS_UNIT_CYCLES:
> > +                     TEST_ASSERT(pdesc->exponent >= 0,
> > +                                     "Unsupported KVM stats unit");
> > +                     break;
> > +             case KVM_STATS_UNIT_SECONDS:
> > +                     TEST_ASSERT(pdesc->exponent <= 0,
> > +                                     "Unsupported KVM stats unit");
> > +                     break;
> > +             }
> > +             /* Check name string */
> > +             TEST_ASSERT(strlen(pdesc->name) < header.name_size,
> > +                             "KVM stats name(%s) too long", pdesc->name);
> > +             /* Check size field, which should not be zero */
> > +             TEST_ASSERT(pdesc->size, "KVM descriptor(%s) with size of 0",
> > +                             pdesc->name);
> > +             size_data += pdesc->size * size_stat;
> > +     }
> > +     /* Check overlap */
> > +     TEST_ASSERT(header.data_offset >= header.desc_offset
> > +                     || header.data_offset + size_data <= header.desc_offset,
> > +                     "Data block is overlapped with Descriptor block");
> > +     /* Check validity of all stats data size */
> > +     TEST_ASSERT(size_data >= header.count * size_stat,
> > +                     "Data size is not correct");
> > +
> > +     /* Allocate memory for stats data */
> > +     stats_data = malloc(size_data);
> > +     TEST_ASSERT(stats_data, "Allocate memory for stats data");
> > +     /* Read kvm stats data as a bulk */
> > +     ret = pread(stats_fd, stats_data, size_data, header.data_offset);
> > +     TEST_ASSERT(ret == size_data, "Read KVM stats data");
> > +     /* Read kvm stats data one by one */
> > +     size_data = 0;
> > +     for (i = 0; i < header.count; ++i) {
> > +             pdesc = (void *)stats_desc + i * size_desc;
> > +             ret = pread(stats_fd, stats_data, pdesc->size * size_stat,
> > +                             header.data_offset + size_data);
> > +             TEST_ASSERT(ret == pdesc->size * size_stat,
> > +                             "Read data of KVM stats: %s", pdesc->name);
> > +             size_data += pdesc->size * size_stat;
> > +     }
> > +
> > +     free(stats_data);
> > +     free(stats_desc);
> > +}
> > +
> > +
> > +void vm_stats_test(struct kvm_vm *vm)
> > +{
> > +     int stats_fd;
> > +     struct kvm_vm_stats_data *stats_data;
> > +
> > +     /* Get fd for VM stats */
> > +     stats_fd = vm_get_stats_fd(vm);
> > +     TEST_ASSERT(stats_fd >= 0, "Get VM stats fd");
> > +
> > +     stats_test(stats_fd, sizeof(stats_data->value[0]));
> > +     close(stats_fd);
> > +     TEST_ASSERT(fcntl(stats_fd, F_GETFD) == -1, "Stats fd not freed");
> > +}
> > +
> > +void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
> > +{
> > +     int stats_fd;
> > +     struct kvm_vcpu_stats_data *stats_data;
> > +
> > +     /* Get fd for VCPU stats */
> > +     stats_fd = vcpu_get_stats_fd(vm, vcpu_id);
> > +     TEST_ASSERT(stats_fd >= 0, "Get VCPU stats fd");
> > +
> > +     stats_test(stats_fd, sizeof(stats_data->value[0]));
> > +     close(stats_fd);
> > +     TEST_ASSERT(fcntl(stats_fd, F_GETFD) == -1, "Stats fd not freed");
> > +}
> > +
> > +#define DEFAULT_NUM_VM               4
> > +#define DEFAULT_NUM_VCPU     4
> > +
> > +/*
> > + * Usage: kvm_bin_form_stats [#vm] [#vcpu]
> > + * The first parameter #vm set the number of VMs being created.
> > + * The second parameter #vcpu set the number of VCPUs being created.
> > + * By default, DEFAULT_NUM_VM VM and DEFAULT_NUM_VCPU VCPU for the VM would be
> > + * created for testing.
> > + */
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +     int max_vm = DEFAULT_NUM_VM, max_vcpu = DEFAULT_NUM_VCPU, ret, i, j;
> > +     struct kvm_vm **vms;
> > +
> > +     /* Get the number of VMs and VCPUs that would be created for testing. */
> > +     if (argc > 1) {
> > +             max_vm = strtol(argv[1], NULL, 0);
> > +             if (max_vm <= 0)
> > +                     max_vm = DEFAULT_NUM_VM;
> > +     }
> > +     if (argc > 2) {
> > +             max_vcpu = strtol(argv[2], NULL, 0);
> > +             if (max_vcpu <= 0)
> > +                     max_vcpu = DEFAULT_NUM_VCPU;
> > +     }
> > +
> > +     /* Check the extension for binary stats */
> > +     ret = kvm_check_cap(KVM_CAP_STATS_BINARY_FD);
> > +     TEST_ASSERT(ret >= 0,
> > +                     "Binary form statistics interface is not supported");
> > +
> > +     /* Create VMs and VCPUs */
> > +     vms = malloc(sizeof(vms[0]) * max_vm);
> > +     TEST_ASSERT(vms, "Allocate memory for storing VM pointers");
> > +     for (i = 0; i < max_vm; ++i) {
> > +             vms[i] = vm_create(VM_MODE_DEFAULT,
> > +                             DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> > +             for (j = 0; j < max_vcpu; ++j)
> > +                     vm_vcpu_add(vms[i], j);
> > +     }
> > +
> > +     /* Check stats read for every VM and VCPU */
> > +     for (i = 0; i < max_vm; ++i) {
> > +             vm_stats_test(vms[i]);
> > +             for (j = 0; j < max_vcpu; ++j)
> > +                     vcpu_stats_test(vms[i], j);
> > +     }
> > +
> > +     for (i = 0; i < max_vm; ++i)
> > +             kvm_vm_free(vms[i]);
> > +     free(vms);
> > +     return 0;
> > +}
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index fc83f6c5902d..10385b76fe11 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2090,3 +2090,15 @@ unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size)
> >       n = DIV_ROUND_UP(size, vm_guest_mode_params[mode].page_size);
> >       return vm_adjust_num_guest_pages(mode, n);
> >   }
> > +
> > +int vm_get_stats_fd(struct kvm_vm *vm)
> > +{
> > +     return ioctl(vm->fd, KVM_GET_STATS_FD, NULL);
> > +}
> > +
> > +int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
> > +{
> > +     struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> > +
> > +     return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
> > +}
>
> We don't want to add a test case for testing the fd interface on a
> deleted VM and a deleted VCPU ?
>
> Anyway, for the current content,
>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>
Thanks Krish, those invalid fd tests are added at the end of
vm_stats_test and vcpu_stats_test.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
