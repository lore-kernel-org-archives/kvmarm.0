Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F9B3D3A0
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 18:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LLpUWe5j"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1c9bc9e6a89so21617945ad.0
        for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 11:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430975; x=1699035775; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pX02ozc7lSRzYa356XIJ+CMNCgv5fZ3NEfG1CClMU1M=;
        b=LLpUWe5j53Q2Qoj5C0JgDaK1hUcbx++WiyWKkLCHDbKGvfk9muWQKGv2QTJG9RM6Ac
         NccYSKpfFYRWfXhfQ+eeYlTU1PgUEk4j/T0MCmCcfqj2/bLBRmW3rAVGrbIj+GsszYVR
         729M5NT1LgnBPSkE5omqKvx6Vq8pexOqIvdyr4HQcM/cBs62//Y+V3e8jsLV6THqMJoF
         1Qc4uBWYslDmg3NErSMEOB5OskJEI7+JZJtN0bII0SZbdIhzdZiq7w8tAcOBd2jv91X2
         6d1gZNv+IIqCldJvEHrqg/tFZsxcRzvuBKcdeLWw++vCwB2DZHrLWyS6JRZqLeUBwUwD
         501g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430975; x=1699035775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pX02ozc7lSRzYa356XIJ+CMNCgv5fZ3NEfG1CClMU1M=;
        b=jFiMMw9Lh1aXI/79ksCgA7Wbqm6gjCWh67EdEtgP+XHa6B86EAHHI6/4Im/5WK5APh
         WfRAMQXaS4YNmkr5MTGt/kZ8iq3Q8QY37ypXAwqyHS7X+fy+KlMaNLqzeOUDWfZUYPiH
         V46xPn6rVkLY0H5fxnQLGEh1uLnYgDwpsME9QdfJ21Cno7WjIbF2VJfU2gdtQHaUyO8i
         OIEYzcfIO2zwDPzJwpw9yaA92XYt+Jg8f+cGnpm4em4NzQ5SFY5KVFIBUoABBAPhUJMR
         elI5Tl5gDBEUk/DAYa5xi6zWBlsU63uo5EK9AVEasikI1zUgM/fPV4TSMX9GVsfOYb0d
         2mpA==
X-Gm-Message-State: AOJu0Yw2H7ygwQj3OapsHAYTWeEXXRBNPjJK3EnOkzNW9Tuh/BcKp3x1
	QD1r1JMCtv0gpQvaCdbTB8RHDjMgLTA=
X-Google-Smtp-Source: AGHT+IEZ2DkPV4b8zDYsItSE8S6PNMt34EGJVQ4YpOaZs5hBhRUHv0wBQpomiC7JG41zMwbv7hAHGw5rsZI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f7d6:b0:1cc:23d2:bb94 with SMTP id
 h22-20020a170902f7d600b001cc23d2bb94mr38516plw.1.1698430975510; Fri, 27 Oct
 2023 11:22:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 27 Oct 2023 11:21:57 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-16-seanjc@google.com>
Subject: [PATCH v13 15/35] fs: Export anon_inode_getfile_secure() for use by KVM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Export anon_inode_getfile_secure() so that it can be used by KVM to create
and manage file-based guest memory without need a fullblow filesystem.
The "standard" anon_inode_getfd() doesn't work for KVM's use case as KVM
needs a unique inode for each file, e.g. to be able to independently
manage the size and lifecycle of a given file.

Note, KVM doesn't need a "secure" version, just unique inodes, i.e. ignore
the name.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 fs/anon_inodes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 24192a7667ed..4190336180ee 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -176,6 +176,7 @@ struct file *anon_inode_getfile_secure(const char *name,
 	return __anon_inode_getfile(name, fops, priv, flags,
 				    context_inode, true);
 }
+EXPORT_SYMBOL_GPL(anon_inode_getfile_secure);
 
 static int __anon_inode_getfd(const char *name,
 			      const struct file_operations *fops,
-- 
2.42.0.820.g83a721a137-goog

