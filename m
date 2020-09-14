Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00C2C43461
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8363920771
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="QYAJeh3Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8363920771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BE7C4B58C;
	Mon, 14 Sep 2020 13:28:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VkeMtluJUdSv; Mon, 14 Sep 2020 13:28:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2074C4B591;
	Mon, 14 Sep 2020 13:28:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C347A4B57A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8FiMlnk9DNTu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:10 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88BCC4B49A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:10 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id b79so845578wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=f1Yic7ZFZnWbBrZg7HASMUx7n5dssR2OZo/o20looTY=;
 b=QYAJeh3Q+9jHTWY5pAYKVdbC19xxu8ncb0TEqMua4SAPTHthmWkX9+Px4bz0H26kWs
 6I/8bZ4ODyxi7WH5k6f6b+s9kmbHCeTl+tfRlX0bnULiJo010jodXWbFD8SVsMqwup4I
 ranJQ2a5yOZvCCFDvOUspxSVCwVf8U0EaBG4mpE+5Gn9jVn3kJa4JLb9x4guXwj5i4rb
 GvPiDjVjO/NaUXS7cSrcp1NQTKBiN7a0tz4VWC74xeF0p8I/9vSbS067MRKNUduneB+J
 zohifeHywe3Gjddluj1vmPUNN9NQBRDr1Bb2lSSSuwWAXQ9XfUh5b/vXVJKRsaf4p2Kc
 ZvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=f1Yic7ZFZnWbBrZg7HASMUx7n5dssR2OZo/o20looTY=;
 b=nuSVmGVfnEVHF9rFNNzzmI/ltjJsgAk04r/vvR1tIgGNbvXO4KC0Wjqt7D1g+IVJ8f
 N2nlVS+uwvYzsct8ou2I7m4Z0R/DlSUWlCwlgOBE4Dlc83gTOICRlCFJOaT+/Ab8F5kn
 3Y/qcEc92abi0D0A3mCmaN8dv/cEjA+B5DIVW/40hTEX7Mzo26PLIZQpYomXV5zQNLGl
 iEPMaKZVaEz161Gp71y2RFOvysVKXFKktL286T4C9j80SjZAkyutVcw117TZyq/3u/CB
 mtYKzke0kdYJ21vIm2yZp1pYmeQzK2W01OOUmRGh9KnLDsmUhtWhXxiAXVBWZQcBBzEQ
 7wlA==
X-Gm-Message-State: AOAM531D0JYrABK8BjeOYCNZAJSrD+/dOvto0jKfaHBiU1aZ+WExqcu9
 Qdc8XnlRpQqvZvJzFwV4o2Itgg==
X-Google-Smtp-Source: ABdhPJwVPwGHg4dpWPy9oWTZbgeAo0d2o5bEHs5LmN11i0q+vogMdLJSPpEQ4lXgcBg5Y9aKVbtpdg==
X-Received: by 2002:a7b:c3da:: with SMTP id t26mr422196wmj.23.1600104489670;
 Mon, 14 Sep 2020 10:28:09 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id u126sm23949690wmu.9.2020.09.14.10.28.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:28:08 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 04/14] KVM: arm64: Add support for buffer usage
Date: Mon, 14 Sep 2020 17:27:40 +0000
Message-Id: <20200914172750.852684-5-georgepope@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200914172750.852684-1-georgepope@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
MIME-Version: 1.0
Cc: arnd@arndb.de, elver@google.com, tglx@linutronix.de, keescook@chromium.org,
 maskray@google.com, linux-kbuild@vger.kernel.org, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 clang-built-linux@googlegroups.com, broonie@kernel.org, dvyukov@google.com,
 natechancellor@gmail.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: George Popescu <georgepope@google.com>

Use init_kvm_debug_buffer macro to init a pointer to the kvm_debug_buffer
and a pointer to the write_index. It is needed a hyp/nVHE version and a
kernel version because there are required different functions to extract
the per_cpu data.

Iterate through the buffer using the for_each_kvm_debug_buffer_slot. The
parameters are the buffer's name, the buffer's type, a pointer of
the type of the buffer, which is used to iterate through it,
an (unsigned long *) to compute the write index and an
unsigned long iterator.

Get the buffer's next empty slot using the kvm_debug_buffer_next_slot function,
the required parameters are a pointer to the buffer start, a pointer to
the writing index, the stored type size and the allocated size of the
buffer. This function has a meaning only inside hyp/nVHE, because it
shouldn't be possible to write inside the buffer from the kernel.

Signed-off-by: George Popescu <georgepope@google.com>
---
 arch/arm64/include/asm/kvm_debug_buffer.h | 31 +++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_debug_buffer.h b/arch/arm64/include/asm/kvm_debug_buffer.h
index 30c9b0b1a7bf..e451c11a77a7 100644
--- a/arch/arm64/include/asm/kvm_debug_buffer.h
+++ b/arch/arm64/include/asm/kvm_debug_buffer.h
@@ -17,10 +17,37 @@
 	DECLARE_PER_CPU(type_name, buff_name)[(size)];                  \
 	DECLARE_PER_CPU(unsigned long, buff_name##_wr_ind)
 
+static inline void *kvm_debug_buffer_next_slot(void *buff, unsigned long *buff_ind,
+			unsigned int struct_size, unsigned long buff_size)
+{
+	void *res = NULL;
+
+	if (*buff_ind < buff_size) {
+		res = buff + (*buff_ind * struct_size);
+		*buff_ind = *buff_ind + 1;
+	}
+	return res;
+}
+
+#define init_kvm_debug_buffer(buff_name, buff_type, buff_pointer, write_ind)		\
+	do {										\
+		buff = (buff_type *) __hyp_this_cpu_ptr(buff_name);			\
+		buff_ind = (unsigned long *) __hyp_this_cpu_ptr(buff_name##_wr_ind);	\
+	} while (0)
+
 #else
 
-#define DECLARE_KVM_DEBUG_BUFFER(type_name, buff_name, size)            \
-	DECLARE_PER_CPU(type_name, kvm_nvhe_sym(buff_name))[(size)];    \
+#define init_kvm_debug_buffer(buff_name, buff_type, buff_pointer, write_ind)		\
+	do {										\
+		buff_pointer = (buff_type *) this_cpu_ptr_nvhe(buff_name);		\
+		write_ind = (unsigned long *) this_cpu_ptr_nvhe(buff_name##_wr_ind);	\
+	} while (0)
+
+#define for_each_kvm_debug_buffer_slot(slot, write_ind, it)				\
+	for ((it) = 0; (it) < *(write_ind); ++(it), ++(slot))
+
+#define DECLARE_KVM_DEBUG_BUFFER(type_name, buff_name, size)				\
+	DECLARE_PER_CPU(type_name, kvm_nvhe_sym(buff_name))[(size)];			\
 	DECLARE_PER_CPU(unsigned long, kvm_nvhe_sym(buff_name##_wr_ind))
 #endif //__KVM_NVHE_HYPERVISOR__
 
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
