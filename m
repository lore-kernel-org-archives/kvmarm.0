Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5617B2D9EDF
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 15:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753890748; cv=none; b=QAWV9ixpulGvSZhzJZdNXfcycgCRumIfdceLkueNR+IFFvgTh4V0EUi+vtblfIxhoTSw4GXmt59XDhTz+vjVA4Udja/oc3DEARO+PdnRPIrLMMNSJ29PkOI0dUw6YCPA/MVmQvWpeIo1YMuGhP8mfE3sgPBp3+x42uVeNhG7IiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753890748; c=relaxed/simple;
	bh=KaUzYMzqAKDKj1Ugou6j/Gy3Is2HqkyvG79qzuUKqs0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oRzkE/1cCPin8rSADx1NhmjP7nWHFDPxCOsErwkA59PEvbcSBgYvb1VbNmDufzqJhWN5+cP/Bg8xTEn3IQxUZoU9Npus1tVjRe4kc4h4efSJMsP9dIRQqymthLyi3gHf3jNCYnx53kl2nRiWsjSxrp9FNGaBMnmAZQYlz7fIWb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FC6fiO3m; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FC6fiO3m"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso237121cf.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 08:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753890744; x=1754495544; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J5S/gfwjHD+oJdrQWb3m/7MfRXYBPvNIQcNwOPtzGuc=;
        b=FC6fiO3mE2rUS7HWvtI5YcO0Mp+Nldj5V0K4Fo5C8aPVpjfAfxqVxD7iL+ncnq1tls
         aPoYUxlydLyqcd8Z0B7fiDEttQyLzNckRV+U3tpbyYFIin/aHf+k6myzyj5iHmkNvuyH
         uILTgnCvIkBGV9/uY9H4vHGC71tQE/NznYqGosru20Q2FmZTuOl447vloNdYkOGvcelZ
         4ryKWzl4wgYjbzqsI9oqMl/MPOSkenDqo31gcfVX9TQUtQ71g1psV25uPC0sSm1ks2bs
         lDXDFD/taqXJ8DNZ75dw19+MhWatLvwk6SzYZQGWeS5cbAVptALjh5suSqmOjugPRj7W
         imAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753890744; x=1754495544;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J5S/gfwjHD+oJdrQWb3m/7MfRXYBPvNIQcNwOPtzGuc=;
        b=aAex03YKhJFdZdY+k3iys7wXfrjz26j5QPCCnc5eKWoIdxTF8cOQwD1t4kIBVzol5l
         bfIaCkudcPrXCUfzQl5jQc1GKnJtebHbGXP6Up78tj0PMvzmW3BgCtOieTJSLMp3fGrm
         gI+DN4CMrHc6A2FJr4EYIb6khetqBytxyofqhGGe2LThxHlgjxZEl+VY+SQIqxktlonx
         bXwMzWuKUKjZVZH8gQjGBI6qwKR/mVI6EelSa6IGwGREUTtWl/2siLRmjwwowzVyAilW
         h9Z3Z3RzIL6yj4Ojn/cFHGfm1hIEQc/cQtCtzCdww+5WEWoANjL9vUK3b/ysT05l5CyF
         xVqw==
X-Forwarded-Encrypted: i=1; AJvYcCViYXrZNuBBRH9eyEiDa/SRr1rken6KIitpoTtFyzSBPu8kUbWavqp14wHMIdmG98X0erDRYtI=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywz37yuEw5l90/Frtm2Re56kRNCmY2dPLs3J9Ilr/PtSdRwhNBc
	PgejuOGcpURSlKGlXweq5U4FpLZC25sl2Zw3d9DZ19PolBdBz4fp+cXd2sWYJBcP1VKLnDvWEhW
	vZ9Mm6z74wNUw+QfqBxixY2yg7I4gOtyeeT/dBsld
X-Gm-Gg: ASbGncvex3jbtm/B+BewZbGcIJpufPoGl1Z76IV+v8R20stkBh7hqfzYNJDgXYuFkMQ
	9fZbMErAAM5NX8vZXb6te39WUFEkBf3Hp/u42tdUwQOUevqD4J6kR2U9XIUidFL0gsLWzQ8Z3AE
	GKL6N/wjtqVlxbA9d8XZ1dNxKKtiAFfkkJ+cOiHCPunnCG3Hu2oDVGikYPXoDGq9O/ZEk6i7yJj
	IIMoRk=
X-Google-Smtp-Source: AGHT+IHCoggrbKuqrS/V3GqDELMmyPu68zQZy/cgUabllEs7qJ283gO9wOXP3Z6D76RtekV7nYcliE9mbdlhJ89jyUs=
X-Received: by 2002:a05:622a:b:b0:4a6:f525:e35a with SMTP id
 d75a77b69052e-4aedf608f0emr3661281cf.9.1753890743755; Wed, 30 Jul 2025
 08:52:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-25-seanjc@google.com>
In-Reply-To: <20250729225455.670324-25-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 30 Jul 2025 16:51:47 +0100
X-Gm-Features: Ac12FXzaE318ERqLrJiYydulNyZlDipqqavrDa-QlTdUT7g8r8Yi-Dt4-p51ElI
Message-ID: <CA+EHjTx7V=bHZ3HTN+gK+MzNhwDehiqQXG2r4AYmMKDufYGOww@mail.gmail.com>
Subject: Re: [PATCH v17 24/24] KVM: selftests: Add guest_memfd testcase to
 fault-in on !mmap()'d memory
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Jul 2025 at 23:56, Sean Christopherson <seanjc@google.com> wrote:
>
> Add a guest_memfd testcase to verify that a vCPU can fault-in guest_memfd
> memory that supports mmap(), but that is not currently mapped into host
> userspace and/or has a userspace address (in the memslot) that points at
> something other than the target guest_memfd range.  Mapping guest_memfd
> memory into the guest is supposed to operate completely independently from
> any userspace mappings.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 64 +++++++++++++++++++
>  1 file changed, 64 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 088053d5f0f5..b86bf89a71e0 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -13,6 +13,7 @@
>
>  #include <linux/bitmap.h>
>  #include <linux/falloc.h>
> +#include <linux/sizes.h>
>  #include <setjmp.h>
>  #include <signal.h>
>  #include <sys/mman.h>
> @@ -21,6 +22,7 @@
>
>  #include "kvm_util.h"
>  #include "test_util.h"
> +#include "ucall_common.h"
>
>  static void test_file_read_write(int fd)
>  {
> @@ -298,6 +300,66 @@ static void test_guest_memfd(unsigned long vm_type)
>         kvm_vm_free(vm);
>  }
>
> +static void guest_code(uint8_t *mem, uint64_t size)
> +{
> +       size_t i;
> +
> +       for (i = 0; i < size; i++)
> +               __GUEST_ASSERT(mem[i] == 0xaa,
> +                              "Guest expected 0xaa at offset %lu, got 0x%x", i, mem[i]);
> +
> +       memset(mem, 0xff, size);
> +       GUEST_DONE();
> +}
> +
> +static void test_guest_memfd_guest(void)
> +{
> +       /*
> +        * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to back
> +        * the guest's code, stack, and page tables, and low memory contains
> +        * the PCI hole and other MMIO regions that need to be avoided.
> +        */
> +       const uint64_t gpa = SZ_4G;
> +       const int slot = 1;
> +
> +       struct kvm_vcpu *vcpu;
> +       struct kvm_vm *vm;
> +       uint8_t *mem;
> +       size_t size;
> +       int fd, i;
> +
> +       if (!kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
> +               return;
> +
> +       vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_code);
> +
> +       TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP),
> +                   "Default VM type should always support guest_memfd mmap()");
> +
> +       size = vm->page_size;
> +       fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
> +       vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
> +
> +       mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +       TEST_ASSERT(mem != MAP_FAILED, "mmap() on guest_memfd failed");
> +       memset(mem, 0xaa, size);
> +       munmap(mem, size);
> +
> +       virt_pg_map(vm, gpa, gpa);
> +       vcpu_args_set(vcpu, 2, gpa, size);
> +       vcpu_run(vcpu);
> +
> +       TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
> +
> +       mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +       TEST_ASSERT(mem != MAP_FAILED, "mmap() on guest_memfd failed");
> +       for (i = 0; i < size; i++)
> +               TEST_ASSERT_EQ(mem[i], 0xff);
> +
> +       close(fd);
> +       kvm_vm_free(vm);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>         unsigned long vm_types, vm_type;
> @@ -314,4 +376,6 @@ int main(int argc, char *argv[])
>
>         for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
>                 test_guest_memfd(vm_type);
> +
> +       test_guest_memfd_guest();
>  }
> --
> 2.50.1.552.g942d659e1b-goog
>
