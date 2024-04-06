Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26D61BF40
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407248; cv=none; b=j1SCPFygTLidIoKT8sU1QdQR+covdpoXF8nz2AYs0WDoxNRckrzx5u6fmt2pM9GOQeDpOOPX0kRDC/hRsCcfG3w60Vs3ooV+CwtzIvjSz//QM7nZrZdzQ/iuUdihLxFSUaOBC58s+8TwIruGz9E45nhmICLBEW44YBTYXuJOpxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407248; c=relaxed/simple;
	bh=od27buX75qlekTIQxkP3UT5fuV09JndQX6FYD2vHQr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkN25EpYyKHJF2DKfDKXkbk5SA40iPfF2WlD2GvMXwegNSHgb+9yxIsWI4FKwgvJ5Qr0CF+cLZTh1OG3e+pf1POHXix+nLGtwfkzKwDXWhvicvEiqMmijTMVvWSMhgDu45Qb26dzuqKF50CVHNjoOmCFUxIRmWF0lofyzDd7knc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QPwuKZmf; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QPwuKZmf"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2a2474f2595so2433453a91.1
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407246; x=1713012046; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=74FZsPss0kwxe9NqMeWaPReIQrTUACvwkEx+kD2VIoc=;
        b=QPwuKZmf6k45YEbbefbdgVC/nH1w7TR+0kBkyTEuUbOK/UeIXN0w/qR4/6K0EPyf2W
         1u9X2g3zWUi6NYD0REgGsuHIA4PEDtqXNULsopHIyG13XJjgLSKOhUJ907NbQk0uHenJ
         NdjvXQbzwDGX5Zra61whws+09YIhKRiqs9qVizwOgAY0d7PirW1rgKtZjqyBoN+7+lrG
         bLJmLr+nVRn1t7p4HQhk0Wydg02pyCvOqM1XtvXEbH/8j+zZE8GRnNVThjlp3vExeVq3
         m/eGiT9lCODHtn6QaqKfXEFwa4SyfRqdxRXG/5umusa1zaJ8946HOiGLpEV926pQdzeG
         q0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407246; x=1713012046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=74FZsPss0kwxe9NqMeWaPReIQrTUACvwkEx+kD2VIoc=;
        b=QMebMtJMZawGUHudgrx6kx5tpEuAKrfrdzjFFk8fJiqcdFsHmENpVkv7t70lXp5C7z
         AjVOgCOtH/0iPHwzfTpHygJY2SOpBpz66uM/BCFv8bwWRW0Z5bOabukK4yp+fUYEYemF
         +jWnRp/1XhgKVjGgauQd7bYe1pjekEpaiz0n/bLvQehizuvg1rROrlBtQx9t1nrQ78Fo
         lmkOaEXQvRnXp7ylKAsh9xfVDtb35sqT+UjZQHCMHadqExxMWbBz8bVRHoehlI3FfAYe
         gnSpn06qda1SI/1td6NOQW9L7GBll6ZtcxJVe0TBBkOpNCwyV5Cxm7aYLDo/R4D4qE7k
         +Nig==
X-Forwarded-Encrypted: i=1; AJvYcCXEv84AeWRKUr6obPP49e4Kq0XctTDwcoAnx77tW4UVAR8R0z3gdmsDb3iLpHaGlguojYKfBjPP4JnhFa/Amf38CHhkOoyj
X-Gm-Message-State: AOJu0YwDa8BLE5LJTa3MKDswpBgQU12VpP4zgYmrS4dP2cpWZpcdV8T/
	X44s6Ww5xddmRMmfB792XMh0toNidUMO8GnRopzfNE8iHzZWry2Z
X-Google-Smtp-Source: AGHT+IFgZyVM/wV4gHHTUtKzy2GaH8FYxLa20w79AVDB9o0mSig7OeFOhEaU4CW5c0EVv67nDh4oMA==
X-Received: by 2002:a17:90a:eb0f:b0:2a2:53a5:7559 with SMTP id j15-20020a17090aeb0f00b002a253a57559mr3815747pjz.38.1712407246165;
        Sat, 06 Apr 2024 05:40:46 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:45 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 13/14] shellcheck: Fix SC2048
Date: Sat,  6 Apr 2024 22:38:22 +1000
Message-ID: <20240406123833.406488-14-npiggin@gmail.com>
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

  SC2048 (warning): Use "$@" (with quotes) to prevent whitespace
  problems.

No bug identified.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 run_tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/run_tests.sh b/run_tests.sh
index 116188e92..938bb8edf 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -44,7 +44,7 @@ fi
 
 only_tests=""
 list_tests=""
-args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- $*)
+args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- "$@")
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
-- 
2.43.0

