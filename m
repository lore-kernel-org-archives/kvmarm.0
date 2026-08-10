Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7C83AE706
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 23:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786405501; cv=none; b=IXTPe3RDHa8C8eiHDMUyXSXBoLt9s64li8aSpEDl87fIeS+/3+0EmHGuiINf2oA4Xuk4AWP9wb5/P1Ky6jSSDtXu3HGTkR4kBOnxYuRbqlx/FRiul1RKiZ7fVoYpcSdYxDKkVaetal+41MYU2mMNcF7b8osahlztwZ6s7xCsef0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786405501; c=relaxed/simple;
	bh=33plBrcKy5Ba/ieAnvSmeZoRK1u7IAJOuZUoYzX0htw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qBapsjbrf5tou6NYp+tJmzK5mdCJmqeeM9tp6+IRtM8bNKmtOyjobHgt2Wjvsk0Jd5862hk/N2KMoX1JraLb9yxWfV6AGmfXKec4/vWMvpzukHqBeMK+3FLQg5iNgvjWqRlc9vopXwSOmRRWNYi7sfQnu2VtY/6/ZkqonZ/MfUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GCbXjenu; arc=none smtp.client-ip=209.85.215.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GCbXjenu"
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb733fc5024so437976a12.2
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 16:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786405500; x=1787010300; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lgf1v7ZyMRecW6GzYu5RKpdf3OAqJ1cTW2eoW0KSWKY=;
        b=GCbXjenud+Nc4jR/dbI3LRoT9eY9zSbOeRxpJppkVHeuLt4/uW+aeCfC8f9eZ5aHS2
         tr5VfeDCH42I+rAopNJ0FUnI1Jo/+A6g2ACLzlyLj068/SKWZTApYmrVVvL8bYlNeeeh
         Qjn/wZ+f1HwG0cqjAvRd0h3D6unh8V3K0K/atX+wNU8UD1yWWJ+R5jEsifrb983aDNVw
         9R46FQ1OOmekW/JLUBy7htm/pX5YTPig+Ep+zCB5nR8KTUTT6BFCnnK66MYRTEPTfEgw
         KsWir5/iGUaJPXuHsXQmwTzvcaJ0KVZCBvkTl1oPJEbHc+n4Rlr9Prd5ss7tYvrUafBw
         OzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786405500; x=1787010300;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lgf1v7ZyMRecW6GzYu5RKpdf3OAqJ1cTW2eoW0KSWKY=;
        b=SaZcGiDkV/+9tVEyIfA6HSrVdCodJKZ8fa92XrhfXxuY/a/bOH/2xGkR2lju3OFvxI
         WZSpHJuKjuyczon2X5jGGBvGsS/QyGRy6NlPFzKwdNR7H8fsqrZ2FjJim3oEIvUdwM7m
         derbpNioWGiOCowoWYHMTjJEC1Bte8E3yPuaF0u2UNFj7I0G0+PlpQh9YwYYHEIQhF7S
         vYDRwSAXOXmsMxeASUvto1uHUEhV9GdNtLmRdlOtHAYQQBA9Yo7oSu1ryJwGFDYQ6/fw
         Ln+EXXdEDYlaH97RswaDY0X2TYH7/Pq0AlDM6x3ref8NNtXA4MJyuXTNPm4SWM9pQPmE
         Zatg==
X-Forwarded-Encrypted: i=1; AHgh+RpxzIxDRTN1fW21TtWOfL1oCBbsP7rAH0NU0uuqBc2PyTzWgGgCnbR7CYMLxp6NVqW+p4EHJVA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyvr1PcxY7lTxXj+5aFAoAG+LJvSZiG6kuosus1gKCq8S+ABRZn
	i5OfeKqkDsOrWZJMA7UYwYH7QgJExgkMisxRvOiiw9U6luE8weO/Xoo3XwUpN8teqV1N/MzBMGG
	Br5wBCQ==
X-Received: from pggg21.prod.google.com ([2002:a63:2015:0:b0:c9b:bdf2:2507])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:178a:b0:845:e97d:447e
 with SMTP id d2e1a72fcca58-84f2e040170mr49815116b3a.26.1786405499340; Mon, 10
 Aug 2026 16:44:59 -0700 (PDT)
Date: Mon, 10 Aug 2026 16:44:58 -0700
In-Reply-To: <20260728121138.1103610-8-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-8-tarunsahu@google.com>
Message-ID: <anpieno-RyRl54fp@google.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
From: Sean Christopherson <seanjc@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 28, 2026, Tarun Sahu wrote:
> +/**
> + * kvm_gmem_freeze - Freeze or unfreeze a guest_memfd inode mapping.
> + * @inode: The guest_memfd inode.
> + * @freeze: True to freeze, false to unfreeze.
> + *
> + * This API is used strictly during the live update / preservation transition
> + * window to prevent host userspace and guest-side faults from making any
> + * mapping modifications (such as fallocate or page fault allocation)
> + * to the guest_memfd page cache.
> + *
> + * Synchronization Strategy (Sleepable RCU):
> + * To avoid high-contention VFS locks (like inode_lock or
> + * filemap_invalidate_lock) on the vCPU page fault hot paths, this subsystem
> + * implements a lightweight, system-wide Sleepable RCU (SRCU) mechanism
> + * (`kvm_gmem_freeze_srcu`):
> + *
> + * Global vs. Per-Inode SRCU
> + * ======================
> + * A single system-wide global static `srcu_struct` is used instead of a
> + * per-inode SRCU structure to completely prevent unprivileged users from
> + * exhausting the host's per-CPU memory allocator. 

This argument doesn't hold up given that each kvm structure has two SRCU structs.
