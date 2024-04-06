Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EF42869B
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407230; cv=none; b=Rs56o0T7N8I4nFSXUaf04QN+wfcP4AlmD2UAXNZCxP9jqebjEG3KCebPHI8c6fVUs9EVgWwAUYv116f+fBNWVUonqTMa+DwBGgJ0A7B07WwmZcunYlSP5Q/pRl/HcsY+KuNMAoREnP9uzX6YKsoKqaCqeEMN1r3CK6zi6+Cx9E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407230; c=relaxed/simple;
	bh=FFft7ygHb4sNew26D/dJgFST62xDvyHht1DMBSvtx6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiiyn+CdW8+qDZTRzvO8PJpXKaWIBjCjIWKcowIzwVs+qIytzkTpO89S7CuQZVxf0goyeYhn2fhult6VoD+JWvldo3DJbfVLf/nNri76xLFAJA1obRZXC4qKGFr3T3WmBpeyXr4FrUId4MgmfXqCOXuvw4PRlEEA731HWafcIQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W35SyjVz; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W35SyjVz"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-29f69710cbbso2135557a91.1
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407228; x=1713012028; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtN3qRr/BJ5ghrfuBVmkjt4OGFVHY6H/GotGGIKP5Pw=;
        b=W35SyjVzXrijj1BsjYyKAkRBRYp5W43BNZi1LuCdvkDmFhsAwCT4d1WP8WixdTYt2g
         aLa1/K7vcosSaZqD5Zpd3TUKqTf6Z9czAZ8Jw1iwfNnLK3KNrvpVToEq4vNYDLNnfw5A
         lx8omPgYyblijuDNBzq234YaleFQ5QaJpp1rEweCSxEj4kEdFz26lKzEyi44A9DFEiwy
         wYmjsxOQtET2OoeCjgiLddtMVUQTyi1zCI8g+DHPRA1A7Qv82zueCaSrknFwdtcJkt5L
         gqKedNHOki0kTZlz88J9mqv0nf79CpPVlQraMgDit3wnHHY6Fx26kfTcOikrA3bplLkd
         F7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407228; x=1713012028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtN3qRr/BJ5ghrfuBVmkjt4OGFVHY6H/GotGGIKP5Pw=;
        b=hUC7m47o94xZ2uhzX6Lhhmn0i+7NfrzndrYpGzPB+OXjQnTZL79Qt2diBYGJlOZJ0P
         xfMz/JMP4b6Z4a0Gk1smsyAoVvzrGC72rndr21xDL6NmoyXglUkYcxdA3t/ynOytQanz
         o8lF3FzFMxEpTmhf7Up0T2/2hm5r1ksfmY388EO4tatDQ9l9s/QdZp5hJ6J+t1s7G0Ih
         aKEGMF3cO9D5JzhZKxDo5bOy23G/sMYGJl3IRLrRXxy28VWgMs+L/VNiOgt8D68HCwo+
         3Clz4pPrn8kr6oELG2jD89HBkpudXnCqamKG27O7v/e4X4I+9JjH5uhY1yGJGHI1bYjn
         ffyg==
X-Forwarded-Encrypted: i=1; AJvYcCW8h4y6hcHxpZlUvWshJAY7uPaU8AfIEJ93nUdIiEynBMDdqQtgiBD50559jHZ1+BS8zCfeRnCtxFCiipwMXymqwV8T3UsP
X-Gm-Message-State: AOJu0YxPJfYg7Z3KsK9IZUh68cdfR6U0az+7A3m8wrLELQ9QT6YXccHX
	kcDvyBzYQuu7Cm0IWjHVc8GgP6YlblaHnSpsm3phd3Gir7JqIFQu
X-Google-Smtp-Source: AGHT+IE7xfGD09MIaUCfQ0PlF2nHZILjJWkZ4PfKwm4uXDYYCAtdwhtHcBBozUYIc7FVTGi7mIF6mw==
X-Received: by 2002:a17:90a:4e06:b0:2a2:c812:9648 with SMTP id n6-20020a17090a4e0600b002a2c8129648mr6948766pjh.9.1712407228261;
        Sat, 06 Apr 2024 05:40:28 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:28 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [RFC kvm-unit-tests PATCH v2 11/14] shellcheck: Fix SC2294
Date: Sat,  6 Apr 2024 22:38:20 +1000
Message-ID: <20240406123833.406488-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2294 (warning): eval negates the benefit of arrays. Drop eval to
  preserve whitespace/symbols (or eval as string).

No bug identified.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 95b6fa64d..98d29b671 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -179,7 +179,7 @@ run_migration ()
 	exec {src_infifo_fd}<>${src_infifo}
 	exec {dst_infifo_fd}<>${dst_infifo}
 
-	eval "${migcmdline[@]}" \
+	"${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control \
 		< ${src_infifo} > ${src_outfifo} &
@@ -219,7 +219,7 @@ run_migration ()
 
 do_migration ()
 {
-	eval "${migcmdline[@]}" \
+	"${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< ${dst_infifo} > ${dst_outfifo} &
@@ -357,7 +357,7 @@ run_panic ()
 	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
 
 	# start VM stopped so we don't miss any events
-	eval "$@" -chardev socket,id=mon,path=${qmp},server=on,wait=off \
+	"$@" -chardev socket,id=mon,path=${qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -S &
 
 	panic_event_count=$(qmp_events ${qmp} | jq -c 'select(.event == "GUEST_PANICKED")' | wc -l)
-- 
2.43.0

