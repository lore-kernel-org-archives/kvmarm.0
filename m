Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE001C693
	for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 13:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jpuwcZNm"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5cdfa676fa3so280444a12.1
        for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 05:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253080; x=1703857880; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aeVnbjWEi5yI3wZCxJZ+3TFl6uPEJpXO65IAKcNUOWw=;
        b=jpuwcZNmhU/4RIEntZ5Dv+g4cluEdgHocQCXVDyRXCByvQxmHTjBQ/DPQIqIwWTHm3
         HSzolV9M1kVZj8syIcphcyLl5ZaQzR2sVAT41BBdbbJskG4UFOAbUjYVFmQCsXRE4slb
         NadOn+faOAmFuDykX6ZyyVVtw0Mbo/bSPBWJFQFror8z3dYTIkbRW58UcRGaywzUpONN
         4rfp8sBk/A5gAfqug49sYwxdv+hmSUjSD1AhMZLeUuqvhSeSaiYCaRsBA04WUcGxJt5j
         8bTo9SAc+YoBjWGeOzAAx4769sg/bnulgEvqx/SxWJQS4DzkXxydUL++de3aGbdWok79
         hWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253080; x=1703857880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aeVnbjWEi5yI3wZCxJZ+3TFl6uPEJpXO65IAKcNUOWw=;
        b=gbW6sHIXJ+IRUnq2luCqmPNzCQpOwTdCNSPhVKEfphC2kqltyE1vgfUprzgkDuoqYd
         sdUwGe3OK7sAaA1gTxt9h+Pt/2BBteHNk3axjprcBQbKemiZtDSYOH2Lj6R31CHNCO6E
         afAZ0zH7w47ZY0Wk4ToCN2nc+s7EHXkgpSTmTQgS4sQFMwsIujPl8szGDmKw1L0dSRfE
         bqSKaKzzoJDDjsm1d39vhdfjwqlSHzQqsIBq07EGGfZaOKyvvkr1rDCix11/+QFDoh+k
         hbs5oIm9JZHRKBbZaZgh9ODfx6hFKy68e5lPNguQzAqaKW0SYrTzMHX4DH6Bgqpa0IFc
         Emcw==
X-Gm-Message-State: AOJu0Ywjq3p8p6yVVELleWKjECAo8BJHcyg9F6WM9J0WrgFitF3ANTvg
	FjV7ufWjK3kMw5XxWq7Okq4=
X-Google-Smtp-Source: AGHT+IHqnb2JvkeLOq0Zyx6dkuBTdsnQ/G+82at1GcM1w/Cj+jE+jQEH5a3pKGr37WxpE4SIFDqkjg==
X-Received: by 2002:a17:90b:1945:b0:28c:191:132a with SMTP id nk5-20020a17090b194500b0028c0191132amr1657944pjb.7.1703253079864;
        Fri, 22 Dec 2023 05:51:19 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:51:19 -0800 (PST)
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
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 2/9] arch-run: Clean up temporary files properly
Date: Fri, 22 Dec 2023 23:50:41 +1000
Message-ID: <20231222135048.1924672-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231222135048.1924672-1-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Migration files weren't being removed when tests were interrupted.
This improves the situation.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d0864360..f22ead6f 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -134,12 +134,14 @@ run_migration ()
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
+
+	# race here between file creation and trap
+	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
+	trap "rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXIT
+
 	qmpout1=/dev/null
 	qmpout2=/dev/null
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
-
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control | tee ${migout1} &
 	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
@@ -211,8 +213,8 @@ run_panic ()
 
 	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${qmp}' RETURN EXIT
+	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
+	trap "rm -f ${qmp}" RETURN EXIT
 
 	# start VM stopped so we don't miss any events
 	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
-- 
2.42.0

