Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBB53C05
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 11:28:48 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id c18so7532937wmr.3
        for <kvmarm@lists.linux.dev>; Tue, 07 Mar 2023 03:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678188526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/NpHgHHJcO9P9YY4y05zXj+B7UDNA2tYv+R1DwR2UQ0=;
        b=LDOhaUxAR+lE9e9uOQ4DrQ8xtL4H+V0Mq5qjEATE3EcyEoWE0CN7ARVyxZl5cCRhD9
         2JqXf6skriwPvRTC7w+8DCIeNgpCSeuvzrPaRYXzBiNp7lggEZQeESfX9+3SPcxDPiOF
         YIUGUTl5GmiFPKNbY00Nnr40E3A1pymHgDI89JVx6/rfoN2iZTXrXGbWhqOMvN1Yv4Pe
         w1ocXTez46XorcVExritLrskAdAv1mAAknlUS9MK/q/zh5+HICh+/ORP2eqAYjbFT0tS
         1OY5YYwYEeP5hkeETCd4WzsA0M54ZS9TnSq28txFc2Pyw55HARz59AQqMCKlMerSMULs
         UgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678188526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/NpHgHHJcO9P9YY4y05zXj+B7UDNA2tYv+R1DwR2UQ0=;
        b=rC/rVQkjcdWKGicQL1d/OtEZsAVwiWx+ItXBKankVd58/Z5HIo0QxfVj5M8eUEfs3O
         1Jdbnkir5sVfquPNgkl878KVulD2RgNRqSQel20K4GfEOb4e9lFLk7JmMP8L74fMs386
         7Ktuxf5C3nCnTcpylDtGLIEhToB5TRRRxeflh31lTLMC9GlMn/pkT8sw2O/KaggHMlHm
         QxiOn0L/8kReTvaa64Ufp5DKhINsMAicZL6ZhWchsKnfFDqRqVZRkcoCpSe7qy1/7Z1U
         3pBjSK7jaHoTjRSjmHlrMjrQEpwT0kH/wcjTtnGA9e2Q3rZ6FGIYbFXOGRu+2D6aFvjG
         OOdg==
X-Gm-Message-State: AO0yUKUSod2dsc+w1nZ/JBn4qawdSSQWEJlTbKWVGyrHkL+teYzSOi4f
	PNNTEoBjAJtQ8lYoO0FOu6kcyg==
X-Google-Smtp-Source: AK7set/j9ovj0CFUUtv3ykxWrPRvhqbtXL2N9dsysSaUAlaQ0uFTi5LvTj/bxwKZiR+m6qk7FlHIGA==
X-Received: by 2002:a05:600c:3b95:b0:3eb:2da5:e19 with SMTP id n21-20020a05600c3b9500b003eb2da50e19mr12222106wms.27.1678188526577;
        Tue, 07 Mar 2023 03:28:46 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id h19-20020a05600c30d300b003db06224953sm12347034wmn.41.2023.03.07.03.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 03:28:46 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
	by zen.linaroharston (Postfix) with ESMTP id B4A491FFBA;
	Tue,  7 Mar 2023 11:28:45 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvmarm@lists.linux.dev,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v10 2/7] add .gitpublish metadata
Date: Tue,  7 Mar 2023 11:28:40 +0000
Message-Id: <20230307112845.452053-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307112845.452053-1-alex.bennee@linaro.org>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This allows for users of git-publish to have default routing for kvm
and kvmarm patches.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 .gitpublish | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 .gitpublish

diff --git a/.gitpublish b/.gitpublish
new file mode 100644
index 00000000..39130f93
--- /dev/null
+++ b/.gitpublish
@@ -0,0 +1,18 @@
+#
+# Common git-publish profiles that can be used to send patches to QEMU upstream.
+#
+# See https://github.com/stefanha/git-publish for more information
+#
+[gitpublishprofile "default"]
+base = master
+to = kvm@vger.kernel.org
+cc = qemu-devel@nongnu.org
+cccmd = scripts/get_maintainer.pl --noroles --norolestats --nogit --nogit-fallback 2>/dev/null
+
+[gitpublishprofile "arm"]
+base = master
+to = kvmarm@lists.cs.columbia.edu
+cc = kvm@vger.kernel.org
+cc = qemu-devel@nongnu.org
+cc = qemu-arm@nongnu.org
+cccmd = scripts/get_maintainer.pl --noroles --norolestats --nogit --nogit-fallback 2>/dev/null
-- 
2.39.2

