Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A4A6A00C
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 11:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714563045; cv=none; b=K0c+Fg2BG84a0jbY00Nsl4VbN1W/b5JueVjFdRXhiDsyeHNPSklxY6YksdSQinMs9yqJ9eSIDSR9pNLh7EECxnQ21/F3g4D5ns0T/s1dERypxNoI5t0LLgywqNM+8xrYmzM0h/pgFYRU06cE9Qo1zgTIVUCoRfBnqeethWvFtSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714563045; c=relaxed/simple;
	bh=FFft7ygHb4sNew26D/dJgFST62xDvyHht1DMBSvtx6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3UlJPmt+g6g/Omzq/VP5OwVll6OkWBVRpSee0xown0rVUtBJ/H1EpV2wdva/X8XqznqaRAXh3u1piLdLZ9PSOCbXWNgpPHDLF/w66VhSXttXyxkLDElBGeY9NDulInmNw9wloqlMxnoNY/eEngdEy7RQKrEP4V+uKIs6SBcMUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ERXsZET2; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ERXsZET2"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1ec92e355bfso4732065ad.3
        for <kvmarm@lists.linux.dev>; Wed, 01 May 2024 04:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714563043; x=1715167843; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtN3qRr/BJ5ghrfuBVmkjt4OGFVHY6H/GotGGIKP5Pw=;
        b=ERXsZET2eQheGbKNcXfFk6tuIEV3v9VlYJZwzihpfoq5k8+IWQQ9A0etFWF4YLzpWH
         cZk5epohlgCT1RUCoQZ8xk3g/si9YKrFSP9/pVmh/CMdIofWK9c8hyjwNsr2oY+qKX0w
         NYDw/7PcIg2QMo9dgWBEihhsBcIw7SpDI3Dj0WBiau3G2sJtbI1fMfSmwLVs3svm/w/e
         RC9cvT70Adb0sL589gX0ccmRsjcyKOnO3rUIV6OPPHshO+axcFTmx88Zgg91pmGX2rzT
         xvp8tSdTUhr5pfXb4ImOwGgZ/MjElpZoj21ACOrQyk8hS+m/J3QYhBkzJWcRsqx8BXe4
         pCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714563043; x=1715167843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtN3qRr/BJ5ghrfuBVmkjt4OGFVHY6H/GotGGIKP5Pw=;
        b=hjgx0YFlC5Bj18FRBjXn3O5P3TBG1uj2BAD/eB22sBVGhn4JyRpbfhPOzgpSvG54Bm
         J0HnFvyAogyvmFhj3UsIbZxlvcGV1ICCdxKGzgjpVxz7vxnocnOmMvLgmQzzc5mqK+up
         HAfuzlmpBpe8e77Epgn+Fsi6p0CFMBySgy0hEAzUyiMEL2S/avatiIE7lgIkWO3R+9w/
         Tt1JqYLsnjjlKCnpjNEC05mdQ9GTusW2FdvIA881d6RL/a0yrXfFtnNMN9DgKmICHdL2
         K30tmHu8quiRyEoulQbic5eKjDmu/wDb1J2cXyw13tYBlIXCp90nL40Y5J7LDV4+z0n2
         Ildw==
X-Forwarded-Encrypted: i=1; AJvYcCXATgcFsWD2HgZxDfFrC8iy5+1mPTEuqBw2LUzKzVXrd7uemcT/3XdcEskyN3PUlrLUZEAPdjvYEMOXPOFBSh7PkvDS42qt
X-Gm-Message-State: AOJu0Yy6FbfgnQ0fNrkv9QmlsoxPSGYogRO5Db/ZcGxDnnj023wyebuI
	umxaoaLgO+S18QNIJ4KDm0nhlgtFmvxlndzz4Q0Yk+0645y1BL2X
X-Google-Smtp-Source: AGHT+IHV5oYZmLZqhk7vquCKub62gii9ohDvIT5N0GBLR7bQIFTMvArnXy34z/49jHpv24YnONJaaw==
X-Received: by 2002:a17:902:d506:b0:1eb:2fa0:c56f with SMTP id b6-20020a170902d50600b001eb2fa0c56fmr2440147plg.35.1714563043212;
        Wed, 01 May 2024 04:30:43 -0700 (PDT)
Received: from wheely.local0.net ([1.146.40.196])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090264d600b001ec64b128dasm2267150pli.129.2024.05.01.04.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 04:30:42 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 4/5] shellcheck: Fix SC2294
Date: Wed,  1 May 2024 21:29:33 +1000
Message-ID: <20240501112938.931452-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240501112938.931452-1-npiggin@gmail.com>
References: <20240501112938.931452-1-npiggin@gmail.com>
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

