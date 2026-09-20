Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730554756B5
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933089; cv=none; b=NflTa81XIt6Jgc8XmpSUKn1PdyHOlQg9Lg+uoZSjFi9/2ybSHBdWyLBXRy+mlHAKBqd5oSklfAHzHdMGpMjkhCO+pWMpvuNC/cjniprDB/MfMfRc2Ux0YyYakKtkeuzstWFCVlV/t3Ya8C4codPIxLkLfFaAJN4Bj89XxdwH9qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933089; c=relaxed/simple;
	bh=vD3k0UChVcsUPV8WCpzl60xjcOJJ7AH4O6Kwg/ASCvo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mao8YbMXa//ueoplO6UohbRN4j0ZXgKQmnRFshbdUZbKn5ZTlPcPSj9LOEfAMjzvzMhKFSKrFzAx4l3LnV3G7LZ1EACBrkW+tgY+hC+X6s7oGTu+L/ej3vfssZnc7Acj0o8TzrurMlRcu6xsaXWz28rIWjZbIfroMDq3sxpdsFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=T0yii8tb; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="T0yii8tb"
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aac92dbso1961212d50.2
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933086; x=1790537886; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Xd0t5fQ0wbqovFneONezXRLopfuFSVDwWIsqSLQ6+6E=;
        b=T0yii8tbyBOwj6FqX1/pKkiqKSqll8jYqNY+b3324+xzDSw0cJwOmurF7rd5Zrfiw2
         S+TFsiXomuZ2JoDs2xxDsVCzOSKevX7dTNKs3xMmnLVzLQrK1O0brLDrMseGTEJXgNEj
         WyEAJt/xe/2sD6jSU5CdNprjFN05VMn0WFRDf+zgDCpdlj9FfoMfGj64wSgdnIpvhiZ9
         7n83MQVosUeJIKH1jVRx17HkBWvmEuI0bwpyOB7w1u+TnclaZlhj8W17/2ftES9W5zlf
         bp6eY4JJj73+crAXoM3jCWkb52dgzhSDtaFJg5yD/XaBZiZxXioLMpcEhivQdZWvsX/l
         oBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933086; x=1790537886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Xd0t5fQ0wbqovFneONezXRLopfuFSVDwWIsqSLQ6+6E=;
        b=JdX4EwyUORvxsNm8580XzuEgcv2+VkRvuwReS88tjM0jTrFmddes7sK6qgbnW68XYQ
         Szgavw5T3kG0lw1+1dASV3HLGGrwiKnYMjdSpFl4w2UFKGXoQ+HUaJKtePkdCNEatYzT
         NhXDPmciqm1/cDaFIc6lnWvV5LzKv9taMz+bWtJEKDEhKDE049hfVsns5edFrbv5EKYz
         vo1f4rMGtPR+tDe/Vp98mrJXa4ZyrYNKDs7sndpQfClPo0DBP17K9RFlhYGm5/a70tbu
         LCoS5rAMpoJbDWm7QfdxRMPBShq8/JS1nirLNMwa3VS/xbdQ/44+OGdu2oqyMy5JHwt8
         7MoQ==
X-Forwarded-Encrypted: i=1; AKwUvBwMOc8DR/Ul5wgg/qzkSY64jLq87mb/S2mmESqlhPy/kazsX3rUto3HFZzitveUJAjcLqnq4i8=@lists.linux.dev
X-Gm-Message-State: AFuF++n6VzPKeiHOizFvsYbnm2U9P8qx3BKD+WZqFmNq4swxabiH0Ust
	jjFYLM3SNOyp3tCnF+qljHeY1c1u8c5qTiws9ArO1okML7wLREwjHbXWl09IQxNalFM=
X-Gm-Gg: AYBFou3ZOgDqjI6kUG0BVQDjs0889zT/I5Z+jkTKJMS6QTr0nB/BAc7pc146e8fnUQ/
	/lnlNu/VnqfJpzyKZ9KeenTd+dSO0RLHx4aGoBdUXdfj6TRXHP8gUPOFmVVtdyTyhCTQXRKkSRw
	pk6ACdlhgW7d5qeQu93+SFvuUZAQTITKl2GySArP2ESnaaydiGga2X22wYAR9kyP93ZtJ9twXcc
	2X1a0JRdRsYF67lZBmBqKK1M/Uz1iJiJhCtW+ZpWWxPRiBgDkZi362Uf17WbCJ/RfHRbvxcpXqq
	Qlk9O9mN0yRhiSVAk0vj43cjzXQoQ9jPW7846QR4oowP9P7+6GRT+FJMQN05ACjlYaDGEUqUXI0
	/x209puOWPTbnHXD7ggvx7GzPONpK0HVklGhHMIAmAhX+sSaqgaoWQtlourKvxRjFLqbWs0C4ic
	NfFFoEsOIUaWseBJSZ/Y5+5JN9J5wTZjJK0yGrL7p6Vs87obALHNJm2fossbZjAm6ldaVN6p+lA
	n5a659V6BLECJ8yTxuXeM8NvGCRYUIlltBlWdl4FQ9VzeVcP22tcKtmKqR+PjwZBDBk0pfNxTwh
	LrVsULbnKq7wEvUVRow=
X-Received: by 2002:a05:690e:dce:b0:66f:c1be:a646 with SMTP id 956f58d0204a3-6717fd8f1ddmr2788927d50.56.1789933086522;
        Sun, 20 Sep 2026 12:38:06 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-672991445desm2614214d50.20.2026.09.20.12.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:06 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 12/46] liveupdate: Add liveupdate_session_name() helper
Date: Sun, 20 Sep 2026 15:36:16 -0400
Message-ID: <20260920193650.3373435-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide an accessor function liveupdate_session_name() to retrieve the
name of a live update session from its session handle.

This allows kernel subsystems like CPU preservation to identify the
session managing preserved resources.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h      |  6 ++++++
 kernel/liveupdate/luo_session.c | 14 ++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 6051abc0612c..119ad0f82705 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -256,6 +256,7 @@ int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
 /* Get a token for an outgoing file, or -ENOENT if file is not preserved */
 int liveupdate_get_token_outgoing(struct liveupdate_session *s,
 				  struct file *file, u64 *tokenp);
+const char *liveupdate_session_name(struct liveupdate_session *s);
 
 #else /* CONFIG_LIVEUPDATE */
 
@@ -321,5 +322,10 @@ static inline int liveupdate_get_token_outgoing(struct liveupdate_session *s,
 	return -EOPNOTSUPP;
 }
 
+static inline const char *liveupdate_session_name(struct liveupdate_session *s)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f48e9a4185f9..3c4f195d375d 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -683,3 +683,17 @@ int luo_session_serialize(void)
 
 	return err;
 }
+
+/**
+ * liveupdate_session_name - Get the name of a liveupdate session
+ * @s: Live update session pointer.
+ *
+ * Return: Pointer to session name string.
+ */
+const char *liveupdate_session_name(struct liveupdate_session *s)
+{
+	struct luo_session *session = (struct luo_session *)s;
+
+	return session->name;
+}
+EXPORT_SYMBOL_GPL(liveupdate_session_name);
-- 
2.55.0.1082.g2b9226bbc0-goog

