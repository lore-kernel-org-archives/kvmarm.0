Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3757B17AC3
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 23:49:18 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1b9de3e7fb1so32328995ad.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689724158; x=1692316158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AUBNLiIlxTx1F6mRQya+iPZZUvsAoMeHoSeivXTBAJs=;
        b=m1E5CQsRhxPohHIaVjXNzAfw9sKja8GxErI8tb88+m9ohtM/2UTUV4KI0EStxpO4aq
         e3MZZP48Hes3EH+ziFJ16ESLBaMphjB9wBUbLKvQFLpYn2bcEMb9Uv2TfKXvMSlsG4ax
         +5bc2E2M24iRgByLib+vhoObgGZN9pfMuLHGBIbrmouSiZYtP7I+o1+DUjs0jJquORQM
         WZA9ZhPgQfZ0ViRdW+5zM3kLeIAxBI958QaGMn+cpDeKcYSO3MEZRWesl52iNilZN/Ay
         f7w1zt9jHHbnKZaxjQB9PYpmQD1oIBOzEUWtcHD4Ui+04jNinOeJzuhQDL4PbgsMw1sC
         a+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724158; x=1692316158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AUBNLiIlxTx1F6mRQya+iPZZUvsAoMeHoSeivXTBAJs=;
        b=F/IeYbF7ayMibGXSBjPHLQ64ug9qLOnboxbyWt9k6PvKy/S3TpJijc56uMTLXo8N+t
         Ld/YACCVCu/SEuMknP1KpXoZaMaDW/BvWLFkr3AJxrlyH7gpz1BpYeoBVvAp+P/GZOzZ
         y9Rzt4Sg8egZ1Er22GqcLWuwCqrtNIrXFSvijK4g7P3gvSb2MgzUosWjqo5tzaBgZ40R
         zgPFfQCi4R2OFdtc9BNxvZGvPMHt0QSE6Cbl7VserX8AOzk8RQBrBkE1WFkWv1rO5kxq
         eXNGIgUuFrqY1EYysl5ag1BG5x9Ka9ED+OJg8a9vY3AwNr1drUgQWb5mXGBUn7FM+CgO
         L6Hg==
X-Gm-Message-State: ABy/qLawowol/bxnrMl35f2r1oAQ9Wxdi/HRcTs+S93xI3hXLHc0HXY5
	f67c18cFvneDcnpx1l9sHuCy4XSnNdc=
X-Google-Smtp-Source: APBJJlGZj18kUtv2DZbfIQmZu2TXCF9UTMkYGVm3bO/BF1sxl/m3e0941s7v3QsOSVZsOvdKY/T33+qfBEc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c6:b0:1b1:7336:2637 with SMTP id
 o6-20020a170902d4c600b001b173362637mr16836plg.11.1689724157723; Tue, 18 Jul
 2023 16:49:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Jul 2023 16:45:07 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718234512.1690985-25-seanjc@google.com>
Subject: [RFC PATCH v11 24/29] KVM: selftests: Add GUEST_SYNC[1-6] macros for
 synchronizing more data
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/ucall_common.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 1a6aaef5ccae..8087c877fd58 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -46,6 +46,18 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
+
+#define GUEST_SYNC1(arg0)	ucall(UCALL_SYNC, 1, arg0)
+#define GUEST_SYNC2(arg0, arg1)	ucall(UCALL_SYNC, 2, arg0, arg1)
+#define GUEST_SYNC3(arg0, arg1, arg2) \
+				ucall(UCALL_SYNC, 3, arg0, arg1, arg2)
+#define GUEST_SYNC4(arg0, arg1, arg2, arg3) \
+				ucall(UCALL_SYNC, 4, arg0, arg1, arg2, arg3)
+#define GUEST_SYNC5(arg0, arg1, arg2, arg3, arg4) \
+				ucall(UCALL_SYNC, 5, arg0, arg1, arg2, arg3, arg4)
+#define GUEST_SYNC6(arg0, arg1, arg2, arg3, arg4, arg5) \
+				ucall(UCALL_SYNC, 6, arg0, arg1, arg2, arg3, arg4, arg5)
+
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
 
 enum guest_assert_builtin_args {
-- 
2.41.0.255.g8b1d071c50-goog

