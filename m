Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912D31607BC
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307781; cv=none; b=iYCsSueJgYXhAdl/pK29Hh12DZ6/RRCIZQso68M0LUk4ZLCWwNTWxPgjI3OvloLKA1nTsUhw/3Vk6+x+b/eZvCtJXBp4ZcADGbDnGH8Of4J6dZIN84VcR0uXZbYC+Bpoe1/+5tBYX2769yrhnvu7bSjZNW62sxS85VK+8BfqIJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307781; c=relaxed/simple;
	bh=EAtbJa1uGcSNumSfbYbK82PzgPPN/6qFy0k8JsSEh2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzwu9RdY/Dwn0KBoh4jI2TabmgOv+K561ka1eYVzEqXf6XfgTPW6pIbmtXrt6D1r0jkpQaYJUZ6z6+F1CkaeW41gUzVooPL5YtZ9HAi4irskDnlmRLFLNDODIfP8Bw3evUKwAyt5GaT0HG7XidzEwmhiz4Wu4T7RhacWeHcE0XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPMoHszR; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPMoHszR"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ecec796323so1519670b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307780; x=1712912580; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gmkt4qhFZhSEnd+pxfVPyRti/r9TlYGWMJpmXepb5wo=;
        b=WPMoHszRF9HXm6SIvsYOGJ+wLCCcTpIZ3zd8+zLRtuhr6bSRCwS5kT78nY2XZ7sU1R
         vhrzayBMCnqoo0k9pZuZ/JllA1pya+7Wth/+kyqjenvExn06jvIxFrJMjVbmEATW/hYy
         EIIWrhJedgiyfzDW3YRrr+0SAyyr4UFkJrwJmidRmpiXI5hqYE911PGC5PMGkm2U/eIb
         C0WF1Z458q92r+gTEJADUQXfAbfvWv9T5WcNwI2MR+xqd6XxQBL8HPYVbrtbIKjKKFBu
         aRm5G7ZbXPTU6EGGwf1gHolrL7qd37O6GzjJ+F60kUZ06GCavqrcE9n3jCY88CjQ4vST
         vB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307780; x=1712912580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmkt4qhFZhSEnd+pxfVPyRti/r9TlYGWMJpmXepb5wo=;
        b=RmVmgNknTK+pawwaNsnIQPXLFVeEtSNLSh9Z4UQzyu6MjO6kG0eKapE+t2SPJ+rdMa
         GgfogEqiXoYW779kOSk+HkuX0yjdHkJVWJ1kjtm87McNNHvEGABjvC7If2b/AzsbQYAZ
         VBBOZTv4E+5z0dvQZJOE+tRpPLekS00Luxukei94sg+Tk2m6m3N7bd+wROLg0JNLwPd7
         0lVzp8zwL/MrifP8jaMtxpIoEXZsIUMsL7CTZ46BiKS0cufDkws9A4o7X95xtmZoJqVU
         bH+0TH3l8XzZsPhaiXsacED70X/K3azwyRuOuwFCtiWq/0DYJO98O/5FPnsVlcDFCX5i
         fsfg==
X-Forwarded-Encrypted: i=1; AJvYcCXgdqMNo1vB727Km0jbZrZcZ8OsFbqrl6aaIkJP2Kjdhnx8yDFGsXJSb/mwHNCP9f/ayDu4HV7gcr9ZLijLLitBNIj1vdVo
X-Gm-Message-State: AOJu0YxnNeKKwUB4YGnBvR5sCGY1fh6o/FL1ZGzRDHIPjJxsNC945c+C
	VAS/tVOxeM5srox7+HTJtvknx3cOtfmuZrkxxKIJOc2MqQq2aikG
X-Google-Smtp-Source: AGHT+IGL+jM7I5Xj0jEMVbIu9IEgKgrsozrrThogKrmDVWc//cKRXd3PlSR8uLhql0Pf8HhB7qsklg==
X-Received: by 2002:a05:6a00:98d:b0:6ea:d114:5ea1 with SMTP id u13-20020a056a00098d00b006ead1145ea1mr964542pfg.17.1712307779850;
        Fri, 05 Apr 2024 02:02:59 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:59 -0700 (PDT)
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
	Nadav Amit <namit@vmware.com>,
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
Subject: [kvm-unit-tests RFC PATCH 13/17] shellcheck: Fix SC2294
Date: Fri,  5 Apr 2024 19:00:45 +1000
Message-ID: <20240405090052.375599-14-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
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

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 89a496014..ed440b4aa 100644
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

