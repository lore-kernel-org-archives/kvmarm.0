Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C6D1607AA
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307773; cv=none; b=dw6bltAyGo+F/ElTh1tc4qAMzsi7paMwsdRrwjyn4qKSWo/jcbwS5ho2P5dtR3XjG12MBL16rgCB/mFMlJwGLHhWdJfwrVuHWfukufXoSPbHBVnGxEgon/mLI3jqAcDWzcolncEL8Q0ZnWYMxE8sPDDKCtMb4yd9pExRu6h+22g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307773; c=relaxed/simple;
	bh=6xB+wIQnOPLKF7pHbmVgFhJt61sfpiZqfgj5DzaM+0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF+pQjZ68wV63akNap4huvU4x6TfVuyH81yY6iPViFue17kmkw8h0ZX5sb+q5aJ6ifW0CIi5P0k/eHk+tUc8WEqCwOFFih03PGPHNauEOPEj+6jb/eohFGmQwzcOwri8EhXIzIYmqddRir2slMq9hMtdVvkT1Sx4lJNyyY0rPi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h9zJysLD; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h9zJysLD"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6ecfeefe94cso313275b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307771; x=1712912571; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irIYlf5WoFbPGWpVJt4Aw1Uvp/IzdQOpW5w6SFgi17E=;
        b=h9zJysLDmnERlowwzWxip/kvw2NFbMSJ4a/wYCBzKtM2Yu1Lo/oPYRfg+7k5Pw4RCh
         dYnJSWThKumzG6BvRGJJajAwYAfJyAyUf3gp7UsHh0NcXFI3xQhpI3HcJ6MpWVqHsTna
         AesrX4XAY3j5+RoxWQQCtCYPFs3FDHTv76c2hbIcXBbDBkcOfpVATJvdIb+3NQKHWU5W
         Tawb9AExafR7gYT++nZPWBBXsWyynRcjcsKF4TLY0fKKz2w5qqDTVBwHNO+i4FML6Cvv
         AmxGMGgLsVYKdL1pYgQ78nxOgVqNiMkJTKV7Y5ozQBwCp3VwTIvqmM748JnBBsRtZHCh
         dOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307771; x=1712912571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irIYlf5WoFbPGWpVJt4Aw1Uvp/IzdQOpW5w6SFgi17E=;
        b=lyLy4KER5r+DCu+TgcrHENjIi1rnj8gWAQ6mEhTqlQ3+acSH2/jKWOfAfSOqM/NPKK
         WZcXSUI82lwm4B1F2+nOCDEDyWnU2Q7+R4pTB/cz5+PRTQ3t750NFZ4i6DrvmuAi5qXd
         lHa67Rk0gRE8vetYVcv0IxI6S7j3qiycq/6kqmmPTg7Tp3TDq1joGo27n++XElVKCACh
         FPn/u9iFHjyNdZZcMpelDl8m309BkRD0T67wlnX2BV94cDJVskTXCM2+vcRfXrIy/a7l
         ELgWwrP4DjjmPis4yZyAX+TsbP10ic01X6txJjXIlQZKVyvoKH7l1K7cyDy+qZlkfdOh
         avJA==
X-Forwarded-Encrypted: i=1; AJvYcCVfYHr69gYDOoZy75eELkEJKRaROlDpd2yyjjbHnqrkIl95tCRBr9WnrfM3fIFVJX4TLcNW2ALBANTfPd3eU10+JCURj2Yr
X-Gm-Message-State: AOJu0YzWaEK9G1GezrfhWB0cpE9o5qRTko12vHPx/730iXbMOXiP0syZ
	ulSCV171YkfZ29gwcfevZZC/xz56pFqQ1mbt21XpEquNhA/lxAWe
X-Google-Smtp-Source: AGHT+IElr9+azYHPCzUFeTz1EuYFHglVKOWVA4EowaDvaPKZHxot7h8o9eZbcs6oAHVCQxDmjIZ3Sw==
X-Received: by 2002:a05:6a20:2589:b0:1a5:6fd3:dff4 with SMTP id k9-20020a056a20258900b001a56fd3dff4mr1361769pzd.13.1712307770983;
        Fri, 05 Apr 2024 02:02:50 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:50 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 12/17] shellcheck: Fix SC2124
Date: Fri,  5 Apr 2024 19:00:44 +1000
Message-ID: <20240405090052.375599-13-npiggin@gmail.com>
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

  SC2124 (warning): Assigning an array to a string! Assign as array, or
  use * instead of @ to concatenate.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index e5750cb98..89a496014 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -150,7 +150,7 @@ run_migration ()
 		return 77
 	fi
 
-	migcmdline=$@
+	migcmdline=("$@")
 
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
 	trap 'rm -f ${src_out} ${dst_out} ${src_outfifo} ${dst_outfifo} ${dst_incoming} ${src_qmp} ${dst_qmp} ${src_infifo} ${dst_infifo}' RETURN EXIT
@@ -179,7 +179,7 @@ run_migration ()
 	exec {src_infifo_fd}<>${src_infifo}
 	exec {dst_infifo_fd}<>${dst_infifo}
 
-	eval "$migcmdline" \
+	eval "${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control \
 		< ${src_infifo} > ${src_outfifo} &
@@ -219,7 +219,7 @@ run_migration ()
 
 do_migration ()
 {
-	eval "$migcmdline" \
+	eval "${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< ${dst_infifo} > ${dst_outfifo} &
-- 
2.43.0

