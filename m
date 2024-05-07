Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FE514B97F
	for <kvmarm@lists.linux.dev>; Tue,  7 May 2024 21:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715118457; cv=none; b=kPRfpgRWLA0wn0dxDDWPjn80OMFwu7rX05Bxwbat0g11l1S7OcCG2sQPdf1fMzVqeg+sLwlP/sHhEx6hFyJXhXJ1YUPJRepuAtnFRqztKyPkWF7yvH4M/b0oxau7kzqWAVXEsI6CxLcMaAcEh3FOUcYUrTQtic1gMXoZ39rCF64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715118457; c=relaxed/simple;
	bh=rWVD3Les6HNzGCMpjrx8KhL3+oCBlnrsvxNQZUeaa0A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=taiCQPoD4u6/hltr71rQ2HlqxAUAic0DZSCTT5hSyWwpU+YDV88Lp24YrmLdrxM3aVMfDhRkmdjoKkG9x2zt7zUYGa4cGdYtLN0EI2h0aRCjrg0KRfhhq+i6iCth8BYgqs2R081OJ00EzXSGmnx2pQYYSf3dONzvhn2s38RJx7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FHOKdbKJ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FHOKdbKJ"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f446a1ec59so3345494b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 07 May 2024 14:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715118454; x=1715723254; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GxXvLzcq9DUcgwih3mSAQ78x/pV85qLBcUXkypaveog=;
        b=FHOKdbKJRkmk6ltzUp84mDYJ6YDCgxQjqabGPjsEGDigDUUMzOvzYkONjhOPzupz1U
         pqqIvAJ4gOqmKsMv18RqISHTEm0RtUupH13u5NCRmQfzTplM5Vj1bcxYHFbxmxQ5UBj+
         yxBi8gVzDxb28LBPW2Ku8HDZsbBbFti5MjUxiwuqdoq48tw4G9R0AB4c3Jkgd7bZC1Ar
         6bgHOxhrB0y9y34mTPJ6ZTGXe9cd3lImx9ypV02tp+KrigG491Qp2yyd3hqkUzfzPQYX
         IYafJWWJK2QTfWHWY6ykJf5NWn2RykP7Of2H8uHf507bI/ONkEwsz6BX8p1pDRnBticB
         HcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715118454; x=1715723254;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GxXvLzcq9DUcgwih3mSAQ78x/pV85qLBcUXkypaveog=;
        b=b603QiSq+NK1oRUJxnHvAHpzZ3HeanCvjuU98fAbgALWmw2EjBMic6tIm+ZZsihNI0
         SE/guZlPhrsz5Nu/tqAp7tk6miwc252Xa7iImTqNvecY111UK+7jn1GAzoJEyEPq4RCU
         TIubKAdQ7MJbdw1pFBfxXHZFHU+YvdF7dneE02Pfc3ufdcDEUMjl9QS+eFM9OP13gV34
         l2BECEsoMzvS7HPV+OVDEOCQ3IkidWhv8F5MKDFAe08pVQoj/iI8bvwO0AFX2lFrVX16
         fJI1vwRJIa1OkdAW5iRcDvvvjtU3PuYSOVJ3uHRj434kHL5i3oQLxmCFw35AVOm761OF
         X0Pw==
X-Forwarded-Encrypted: i=1; AJvYcCXsFNgRXnIoQPIoblbd4h/bRPymJxaJB3jEH8kYzDHffiCYMSE0bBI0ldUS2KJs0O868MY0FrbISOad8v5yf78NE4yKWn/z
X-Gm-Message-State: AOJu0YyT+fHL+WIk1OxwAdMAGIgm1LHwENd3YNDfDAkmQF2PbrIZ8OuI
	gXZVJswR1gLXhhcD6xSPYctN3oDlSZ2fB8xlm2qCg6zp4w0rHfQFe4Ts0HLHCD7fxZXAHfR+Q0Q
	DFA==
X-Google-Smtp-Source: AGHT+IGyIuHby3YDnVxOzNzbbaEdY9qKdq7MpmWxi3fRJ7Znvf9dmfYdSTbgOYiGfgZmNPwJBeWALvgDPEM=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6a00:1803:b0:6ec:f406:ab4b with SMTP id
 d2e1a72fcca58-6f49c30a0e9mr48385b3a.4.1715118454141; Tue, 07 May 2024
 14:47:34 -0700 (PDT)
Date: Tue,  7 May 2024 21:38:30 +0000
In-Reply-To: <20240507214254.2787305-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240507214254.2787305-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240507214254.2787305-6-edliaw@google.com>
Subject: [PATCH v2 5/5] selftests: Drop duplicate -D_GNU_SOURCE
From: Edward Liaw <edliaw@google.com>
To: shuah@kernel.org, Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Christian Brauner <brauner@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Kees Cook <keescook@chromium.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, 
	"=?UTF-8?q?Andr=C3=A9=20Almeida?=" <andrealmeid@igalia.com>, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, "=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Seth Forshee <sforshee@kernel.org>, 
	Bongsu Jeon <bongsu.jeon@samsung.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"=?UTF-8?q?Andreas=20F=C3=A4rber?=" <afaerber@suse.de>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	Matthieu Baerts <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, Edward Liaw <edliaw@google.com>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@android.com, linux-sound@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-input@vger.kernel.org, iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-security-module@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-actions@lists.infradead.org, mptcp@lists.linux.dev, 
	linux-rtc@vger.kernel.org, linux-sgx@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

-D_GNU_SOURCE can be de-duplicated here, as it is added by
KHDR_INCLUDES.

Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/futex/functional/Makefile | 2 +-
 tools/testing/selftests/iommu/Makefile            | 2 --
 tools/testing/selftests/net/tcp_ao/Makefile       | 2 +-
 tools/testing/selftests/resctrl/Makefile          | 2 +-
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index a392d0917b4e..f79f9bac7918 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 INCLUDES := -I../include -I../../ $(KHDR_INCLUDES)
-CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES) $(KHDR_INCLUDES)
+CFLAGS := $(CFLAGS) -g -O2 -Wall -pthread $(INCLUDES) $(KHDR_INCLUDES)
 LDLIBS := -lpthread -lrt
 
 LOCAL_HDRS := \
diff --git a/tools/testing/selftests/iommu/Makefile b/tools/testing/selftests/iommu/Makefile
index 32c5fdfd0eef..fd6477911f24 100644
--- a/tools/testing/selftests/iommu/Makefile
+++ b/tools/testing/selftests/iommu/Makefile
@@ -2,8 +2,6 @@
 CFLAGS += -Wall -O2 -Wno-unused-function
 CFLAGS += $(KHDR_INCLUDES)
 
-CFLAGS += -D_GNU_SOURCE
-
 TEST_GEN_PROGS :=
 TEST_GEN_PROGS += iommufd
 TEST_GEN_PROGS += iommufd_fail_nth
diff --git a/tools/testing/selftests/net/tcp_ao/Makefile b/tools/testing/selftests/net/tcp_ao/Makefile
index 522d991e310e..c608b1ec02e6 100644
--- a/tools/testing/selftests/net/tcp_ao/Makefile
+++ b/tools/testing/selftests/net/tcp_ao/Makefile
@@ -26,7 +26,7 @@ LIB	:= $(LIBDIR)/libaotst.a
 LDLIBS	+= $(LIB) -pthread
 LIBDEPS	:= lib/aolib.h Makefile
 
-CFLAGS	:= -Wall -O2 -g -D_GNU_SOURCE -fno-strict-aliasing
+CFLAGS	:= -Wall -O2 -g -fno-strict-aliasing
 CFLAGS	+= $(KHDR_INCLUDES)
 CFLAGS	+= -iquote ./lib/ -I ../../../../include/
 
diff --git a/tools/testing/selftests/resctrl/Makefile b/tools/testing/selftests/resctrl/Makefile
index 2deac2031de9..5073dbc96125 100644
--- a/tools/testing/selftests/resctrl/Makefile
+++ b/tools/testing/selftests/resctrl/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS = -g -Wall -O2 -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE
+CFLAGS = -g -Wall -O2 -D_FORTIFY_SOURCE=2
 CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := resctrl_tests
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

