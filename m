Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AC2311C2F
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 16:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776444427; cv=none; b=akA07CRKGW6tpRdJxA0HMRsubMKDOVwcw9uHL3jPnPdpwujcNx3EZeYrMCFqdSqq2TWzBmLJM36MHQ5smIoHHZp5aIVbhfQ39Gou7XJ3n8fLpq54QLA4Z9w6jOt9nikI0ARjAZnT2EC21Ox/BCWfiB057d0geSRURx+5PCHWzX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776444427; c=relaxed/simple;
	bh=BqkS1+8w7mYYuCnHKvtHMaYkbLA09Qinu7JMt5fNOGM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B7IDiFHReH5NVUYkFGeoOrHy8RVKhk3BIp/CiG8a4k8jqrUl2GQcGXunYGUc3P6eFGVN4G3WfUBmAG9ercFgL9M3WbCBx5dswQo6Hi0uClES/4bJ1DIoLZ4d93s4800if2P/PSU6dfAh8eL9vxSEf/xoNrCtL3+pZg0YIYUW354=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bryMiH+N; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bryMiH+N"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b2ecc96a9aso9497675ad.1
        for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 09:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776444425; x=1777049225; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=THZKYqCh3zVO+So/kaXQTTcEeZfZWD5YDDISxc7lZyg=;
        b=bryMiH+NwmOwJQlb3djxFYD9xoElRl8OUV6zbHnIaeqyqS8LybKkO+X4/iVLpucJ2u
         vF/aLli6WgvtMz/qQM47mV8mxyDDYj+Q8vpkCZuWbKLFbjt9bIFZcDLu/f8oz4S4zrLk
         +o0rOBOGfq7IPak4qU8eRnRAT6o20YBZHm4WUu2F5mrltYaut9AT0gYlq3ppJqt42JAv
         SgW9ne/sQuHv1z+MIVCj3WmKa6NDq77yBiX8Lb3MRIU9uBHrGT4RcTUkw6R+D/zJ3wvC
         YfGG68PbYurE9BZ9+mouYXAadolKxgW/7B+UzZGEY+Aa7aEiQbmaQ5sE3tnpdZiv6K2X
         zdaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776444425; x=1777049225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=THZKYqCh3zVO+So/kaXQTTcEeZfZWD5YDDISxc7lZyg=;
        b=hPoC8tnmigDrambKAd2Wv2zVk70pRb4DnjYKeam96VgsOmRbPl394WSIRVM9BL/7+A
         mnoKobSJn0GasVJGge+3lvpQHeKCoOIhYWg9fXgwItbEOwQk4VCs9Ytdz3p1CQxU4i45
         qv4Wx4jpjPS/lspZBvkDScY4HaPBPm9n9CcEn5jnDpnVr9q5ShwSmsheTHCpLhiPs71o
         4zKJFaTBmECk979gVtrx8KU7+3mrqNzui0y99QkusSHtKPy5bTswiBgolFVLnICAsV//
         vV8W4cWaVzjEJAx1EtGu1vWTjoJskxWoazEH5WqRjZaFts32yEoXRKlVBge86YB6Ui6E
         TaoQ==
X-Forwarded-Encrypted: i=1; AFNElJ9madp2LZlDALM1AoOj3s8uoN/H5XhrO1QHagwDBIIDRjv4/8+DZPIxsksAdfYHn/4B8ZO4MK8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTPpzeCrzDZztP9FrMMpzMb78qCWUIVlMI45fwQTAJ3qpNnU51
	y4J/ryJI+K8MF4bwnqdAqjXRx+Vg4zdMVLSCDav26YAqGUmybPpc9d/NdlM0vYiNPjoEPTpMLH0
	m5YAa0A==
X-Received: from plbiw7.prod.google.com ([2002:a17:903:447:b0:2b2:46d7:4428])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1ac6:b0:2b2:5840:808e
 with SMTP id d9443c01a7336-2b5f9ee9487mr37665585ad.10.1776444425313; Fri, 17
 Apr 2026 09:47:05 -0700 (PDT)
Date: Fri, 17 Apr 2026 09:47:04 -0700
In-Reply-To: <0064952b-048c-455d-ad89-e27e5cb82591@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-25-seanjc@google.com>
 <0064952b-048c-455d-ad89-e27e5cb82591@linux.dev>
Message-ID: <aeJkCGwsrRmuBikT@google.com>
Subject: Re: [PATCH v17 24/24] KVM: selftests: Add guest_memfd testcase to
 fault-in on !mmap()'d memory
From: Sean Christopherson <seanjc@google.com>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 30, 2026, Zenghui Yu wrote:
> On 7/30/25 6:54 AM, Sean Christopherson wrote:
> > Add a guest_memfd testcase to verify that a vCPU can fault-in guest_memfd
> > memory that supports mmap(), but that is not currently mapped into host
> > userspace and/or has a userspace address (in the memslot) that points at
> > something other than the target guest_memfd range.  Mapping guest_memfd
> > memory into the guest is supposed to operate completely independently from
> > any userspace mappings.
> > +	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_code);
> > +
> > +	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP),
> > +		    "Default VM type should always support guest_memfd mmap()");
> > +
> > +	size = vm->page_size;
> > +	fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
> 
> This test fails on arm64 when vm->page_size is 4k and host's page_size
> is 64k:
> 
> [root@localhost kvm]# ./guest_memfd_test
> Random seed: 0x6b8b4567
> __vm_create: mode='PA-bits:40,  VA-bits:48,  4K pages' type='0', pages='660'
> ==== Test Assertion Failure ====
>   include/kvm_util.h:683: fd >= 0
>   pid=889 tid=889 errno=22 - Invalid argument
>      1	0x000000000040262b: vm_create_guest_memfd at kvm_util.h:683
>      2	 (inlined by) test_guest_memfd_guest at guest_memfd_test.c:450
>      3	 (inlined by) main at guest_memfd_test.c:491
>      4	0x00007fff8f56af3b: ?? ??:0
>      5	0x00007fff8f56b007: ?? ??:0
>      6	0x0000000000402a2f: _start at ??:?
>   KVM_CREATE_GUEST_MEMFD failed, rc: -1 errno: 22 (Invalid argument)

Does this fix things for you?  If so, I'll send a proper patch.

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ec7644aae999..c682bda722f9 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -510,9 +510,15 @@ static void test_guest_memfd_guest(void)
                    "Default VM type should support INIT_SHARED, supported flags = 0x%x",
                    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));
 
+       /*
+        * Use the guest's page size for all accesses, e.g. to avoid having to
+        * map multiple pages, but create the guest_memfd instance with the max
+        * of the host or guest page size, as KVM requires gmem files to be
+        * aligned to the host page size.
+        */
        size = vm->page_size;
-       fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP |
-                                            GUEST_MEMFD_FLAG_INIT_SHARED);
+       fd = vm_create_guest_memfd(vm, max(size, page_size), GUEST_MEMFD_FLAG_MMAP |
+                                                            GUEST_MEMFD_FLAG_INIT_SHARED);
        vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
 
        mem = kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
