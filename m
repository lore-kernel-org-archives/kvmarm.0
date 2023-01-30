Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186BC79D5
	for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 19:57:29 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id v37-20020a25aba8000000b0080f1143ef6bso6887822ybi.11
        for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 11:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dc3zeGOnu3cTQ/J5hLWHzEQjalk/Y7p5kM2vIQsVfdo=;
        b=jO+6VN04K/g8QUcbl5dTFT1VhMllp53XmX68l83m+V5lMp+uA+xRKuw1i0xWjHyyKv
         +87p7/8WRZoWFAshisB4RTUVt60qfwGXnJPvWMBfnQUSAUORWrGCaPwQ6ysrJ7FTOE4a
         vhQVfrOXgkVn39i2q9lMSBu9YdcQCGT/MEtCZqVIKMA6scbKR+9gbjUKqPY9jQJGzQjw
         X3e/EzIs8yJw0tgpovn5Gnz83WOlaj/TdFPkf8e6qyebCJeQCJOwgfzrJYX7V5q8cdxM
         CuTJYYr/GB/o6Q4GMqAzXHMnZzlPqy6EQdnGaMspgTIdPS39pGz9jGYn2GTlt0Bfqt9s
         S1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dc3zeGOnu3cTQ/J5hLWHzEQjalk/Y7p5kM2vIQsVfdo=;
        b=g/wJw68nkT2gOGaS2/4kPaBNYndQyaSgBMP92pE9DBRPpQp06mCsq7DGf1KFAlizPz
         BxyZ43+CPpJromtK0PcshVWwJlvKMPWTXM3Lcy4Yr3NIIn8yxqDiKPWWCkLY/yrnQoIs
         ZfzJ/wlCnBshmJ8neroFk+YLBY2uElhYOTpJf4OLt4ywgH7WwqFh/T0tctskeYihUlFY
         He5DTqG990o6T+uCHbb4YyNjJHiPUgzIPHFKbLi1muhr5dE96k3PhnqUNM1fqIrhEv7h
         ZTPCPzvcMYxWeKV7R3SDy5z2tFJOtoD7cbBPVF31AnUg4bsCRqcxDgiwKo/K+j6cItYd
         Pp7g==
X-Gm-Message-State: AFqh2kpF5x/EsICB9PFg/AH4LoPVxwBB2BI9owzv8I8WB/ctI+3xRmo4
	pGoN6mevNb5LHjh41QlLJtWtPLW6nIS7xx/VIQ==
X-Google-Smtp-Source: AMrXdXukGiKGext+HoYi0FMssBPzeNnJoNs6OajphJY57A/gXUEykCiHaxyUvILJUKdjq2uzs/x5YkE3DVGWvtUyBQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:7b44:0:b0:4ff:a70a:1286 with SMTP
 id w65-20020a817b44000000b004ffa70a1286mr3537786ywc.447.1675108649088; Mon,
 30 Jan 2023 11:57:29 -0800 (PST)
Date: Mon, 30 Jan 2023 19:56:59 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230130195700.729498-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v3 0/1] arm: Replace MAX_SMP probe loop
From: Colton Lewis <coltonlewis@google.com>
To: thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com, 
	andrew.jones@linux.dev, imbrenda@linux.ibm.com, marcorr@google.com, 
	alexandru.elisei@arm.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

v3:

Rewrite v2 using one invocation of QEMU and bash parameter
substitution instead of awk. Clarify conditions under which this
change is needed.

Colton Lewis (1):
  arm: Replace MAX_SMP probe loop in favor of reading directly

 scripts/runtime.bash | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--
2.39.1.456.gfc5497dd1b-goog
