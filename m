Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37030657A8
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 07:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462134; cv=none; b=ZCk4l+PKP8lzSb3wnM6srSnKE6yApztL4wqzKYI9BNt6MWKpCmJXu759Wpe/7YjDkgyVw/4dsAvJAH80hjmkDGyeT28YIBYppKKGQQELTVR078eO7Yootm77yzHm4yAg2EoCD5yDfufFtK/fIawR1YMhWEG+X+Z4fOCXyz1yR1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462134; c=relaxed/simple;
	bh=59F2uXNROyyrYFD80n4UUCXU0uos2PlTu+KS2KayEdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qvsvpk1/jv87/p7ZCsDSguLU0N1rkVJGUnFhIt61uJ1Og3OPnUjZsL56DKvvfKZic/CaPDbD3saQyoxpTGjuI5MIxjibMjiYQhx+txsyJp17RlA6cMWR2Is/3OG1nfiQjhpcPwU2zUSZqlSstSkU5t37kJ4yKZXeJbGK/T8PmIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WMetoAD7; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WMetoAD7"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d9b2400910so4791945ad.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 23:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462132; x=1708066932; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZWJe/FfY+0lZ+B78melC7fte3uc1Gnzj5kPj86WV+c=;
        b=WMetoAD7SR6eAVPdr4dqmd4yTcLO5gxumCzMUXR0QtuU/QkNorKN/5G3so/w0vd1/a
         U8+bzfmMdeoRNZxzskSPWeYJuEoUBed7/U6gxC/s/IuSPCBIbJvA29FDLXXDd8W9Us2o
         hmX5ZYKg2lQE5PPpKtLA0hxGVVRiYGwgYXWWRA7Pl71r/TQ7y7qWWE4vzGz2tvUc/nDI
         6o+6oqWIaX/BFTATKABxTLOIhJY+3dMEA4glIgpj/iXVmQVD2nCh3U5x8lVsv7jFpQqH
         BVGky3y7UIuZHdyvGCuEa/FbLz6KfZZL8+/+GHN863quc68SjWXIsIOidt/FqFA6yVBn
         DEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462132; x=1708066932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZWJe/FfY+0lZ+B78melC7fte3uc1Gnzj5kPj86WV+c=;
        b=Y0kmsxgTasKzdOLDq66OyAUgLvq+5d48jKFk+2r9O9XpJ3jNTlkRZEtQSIDLDAXcXB
         1U3OfSwOC8OLO11vCGT+9dOsZI037A09DROsFsSWdUqpDMAxu1WDurwfmKHUsEIxP0g4
         VLa7W3TZWNmruU89wBX0aWkWYAKarzfN7oNVO0i/ipLAmFX8/YM+C9nB4FjtJcS++bVH
         9gGP9Qp+dMbWX41TBx4rIYMZuNbRwuIAUdTVok/gDgozaJrgcIZSo6V+s7LCy6IuBNdE
         pAyvEfogg3LpGIhOx5IDr9I2TzJsqKJMEZRQxEVczW8qSwQMZ+5rwKs5FfcBDoivugGj
         Mi7w==
X-Gm-Message-State: AOJu0YwGTfrGyjA/JttC7uyZXvAYOPp2bbLoPZmfKO0GT52GlBHAjRQ3
	q90NyejrDsjZgmEcX4QumxoN7bn0nOdwHwqpZQrJPQ90ctpSHiai
X-Google-Smtp-Source: AGHT+IHOeahmko/f+RwAZAHEJWia2rOHYMfGMz4gCsHP+DywjdnF57Ty4tjhGRk1+lg6vAvd2PgMDA==
X-Received: by 2002:a17:903:22cb:b0:1d9:efc7:1c4e with SMTP id y11-20020a17090322cb00b001d9efc71c4emr251590plg.6.1707462132399;
        Thu, 08 Feb 2024 23:02:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUjW0aiDCaCLLFfVUVr5+bjGqa7mzeF+p3ViNkQqbgtcj0Il6d+i/6lELOrZwAv2VLO/QuGkDOmTrZv2VMUIMsKQgyI4X6EJsrbFOqX3EwTBCt77J+G785rbh7UEFgzoGo0MeZTvVYFPZD7/1PJ01abi+YorczJW6k6akDxzxMXt9g2gLdOpy3QIpkuiqBIzAePfI7P128W0t4bkitbTsDbBr98gnEpsMuMgQjuH3Si8ur0dF4cnkyVF7dvAjGhMkLgFQmtXBD6lNkbOeef8ggdt/eBtk2c1xZjUn0zCW6G0TMxpZ+4JWMsZF63nPB1q8lKpmVddNx821u3QU0boOD2tlS8wYCQA3O9JUIEQCCb6Qnpm08pHAbnTmgBswHd5imYUiTh9O2eDynpgwF0mNiaOsqavbRC6Jul2MLacr+aprWRyUDanMygM30mw97u0KHVMszGF2zkWJ9/DGlFbxg4mH+LAJXvpwXsmpY+KkbPjxFdxOPeMt3Fc2yK1BQrEDsG6HaRcQ++jE20RCJF/GmJiLzdCsPsWr8F+BeQeiIe7Yj2y2RZ956a
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:02:11 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v3 2/8] arch-run: Clean up initrd cleanup
Date: Fri,  9 Feb 2024 17:01:35 +1000
Message-ID: <20240209070141.421569-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209070141.421569-1-npiggin@gmail.com>
References: <20240209070141.421569-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than put a big script into the trap handler, have it call
a function.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 11d47a85..1e903e83 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -269,10 +269,21 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+initrd_cleanup ()
+{
+	rm -f $KVM_UNIT_TESTS_ENV
+	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
+		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+	else
+		unset KVM_UNIT_TESTS_ENV
+		unset KVM_UNIT_TESTS_ENV_OLD
+	fi
+}
+
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		trap_exit_push 'initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
 		export KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
-- 
2.42.0

