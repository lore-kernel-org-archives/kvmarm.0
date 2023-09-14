Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09DA23CE
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 01:56:32 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-56c306471ccso295980a12.3
        for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 18:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694656592; x=1695261392; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Vjv0zC4RrtxbIkJLIAO5e3EhKuQZW28HjcF6ypERxIg=;
        b=U3Y9+GkV+zQxyKv34vVVgxZcQLO3cdME7EC4GcdTmZGDoViX94aMiveCRm/3FS0yVp
         ahG5mFeUaIo3IGrP3ZPsgIXCc8KDVcqANZVOQx5mdXTB5TmPgQvqnjwdDmjdxDqCpAcs
         vmrNb9IfCUeelij5gQ2UCZS+pXaGCKkmfrFPtwDgPmpL+cciMMH38+eQ0CJD0hmQUZ0s
         b7QwbPc1HS63naHne2MWHObXrh9Ne8Ql3547vLfRQzBPXdQG3rv/WN7xS7aISAO5YYZI
         AUyuWT5nSXIykx3KMiOOfPfbmsM2kVpSnToORwUVdlaX5cwd+NNKTHH5ycsHeXmNKQ7r
         wUCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694656592; x=1695261392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vjv0zC4RrtxbIkJLIAO5e3EhKuQZW28HjcF6ypERxIg=;
        b=So0Z1WuLvIvRMoHr71MJaYdIsSWMyJ0Xai+Or7wCBUtRSX2HUPwKJUPlYqlzzaVKhe
         0eS/+51WocW0H0meEsIrRj+CplFmsIi/maCqi07WZBHdWPxVpRPCfeLizW0D+JYqrNue
         QHvZmTg6xvcvF0a2XYE6yy9zgw0TUcSfHrX2PAhO5LVn2MQP1cB8/s/iI0+3Gd11QsV6
         ddBCYYkZ9J8Pw/USD4j1Til519o6vo9wlzOWOA2ShBh67z0K9jL3aSPnHWInLwcabIfk
         BAKq6a3a9iFU/1QIb6ebNcAhA6htb+ruj71adGU0AQ428iH1dnubVUykpJT+YBOnlZWR
         4C1w==
X-Gm-Message-State: AOJu0YxOACFXNBQo7Pkyl8/YU85gOSbY0hnoPflm6D185BJslBwJaQ+N
	fFUSRfaeFaEuQSzedeJRclUrv0WU1Lo=
X-Google-Smtp-Source: AGHT+IH29SvaM4IJ2/NXJnaPAeFMS+fjtgLQL7Rq48UqpO83PYLOZng2qV6FMiS0c4sL4jzOiYmTHdNxdV0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e551:b0:1c3:a4f2:7c85 with SMTP id
 n17-20020a170902e55100b001c3a4f27c85mr212223plf.6.1694656591946; Wed, 13 Sep
 2023 18:56:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 13 Sep 2023 18:55:26 -0700
In-Reply-To: <20230914015531.1419405-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230914015531.1419405-29-seanjc@google.com>
Subject: [RFC PATCH v12 28/33] KVM: selftests: Add GUEST_SYNC[1-6] macros for
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
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add GUEST_SYNC[1-6]() so that tests can pass the maximum amount of
information supported via ucall(), without needing to resort to shared
memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/ucall_common.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 112bc1da732a..7cf40aba7add 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -54,6 +54,17 @@ int ucall_nr_pages_required(uint64_t page_size);
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
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
 #define GUEST_PRINTF(_fmt, _args...) ucall_fmt(UCALL_PRINTF, _fmt, ##_args)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
 
-- 
2.42.0.283.g2d96d420d3-goog

