Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44005BD25
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 21:55:26 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-4c16ff0159eso176712157b3.17
        for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 13:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vk+h98K5lBZ1bCzuFSe+82Rbn+wHuQAUnYI8WkMMMOI=;
        b=avMM2JU0X4lmETlxVdkMkrdrPhQ0b4xrnVCw/NaGabIDJr0OT0NUtFBKXlZmftj/+k
         3KrqnKWiGt7v7zoD1zgZDz4qkgJTIlX4BpatPOYrvsea4b0w821NOOAVtaflI2/UuCVb
         xLMflreox6WdGXOtrVHDkURwde2QyGfn3/XPhHeqy7OajAc0aUr9/+88PUHyZKJa/1eb
         t8XNhqmWQHrmwFQ0r0kPvYu+7TRPjrN06Yseiw0Wa31UArMRIKqshMf7+F4kcyMhJP2V
         BNz2CSvzoR15/Y5dmbdjLUkz6v64fSKDJKlutFwBeXbb3Wc7nnO1051ySIR1mGcgQPq2
         wsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vk+h98K5lBZ1bCzuFSe+82Rbn+wHuQAUnYI8WkMMMOI=;
        b=NosWG1yzGImi8PCuZnKtnFG+i3pD4/u/H+saz58Y/t/o8tfnYU1axsy3Krdbpiz5zN
         abcB5TeuWWYUZrATkc65F0zzlW9xK4c45l5fZqcf+mxC6tYaiXoO7696VCVi9K+Mlrc8
         S35E30Cib17YZ8ZxLYwISJPIytMVj5j30WgLZ0A6B1hzhl/cc/cCLncA58VZjDs+t5sf
         AMVO2gvWYaCXcrKE+I1Uem4G3qrPjDh1w+d77v1+9YHuJCRlS/KXaQIMTYOtYP1l3cpF
         5lXL4uoce7itygtpfvAeWcv+bd9hxbLO8+6V2ZW+19sAA7cVKIh01JQaG6eShBu9oAU2
         T8tA==
X-Gm-Message-State: AFqh2kpUmXPO++Hbo7hI+YkCPPjYW4/BlKXiumFbn5LnpVQ2jWvKL/F9
	ghyF5SuZk8GBswynMl38ql4qxcuP1JNjMm50XQ==
X-Google-Smtp-Source: AMrXdXsNW5o4o7MCk0DjPQAefT6HrLTRimvDYJJbr5zamKD8u3tg+gV411xOco5ktrlIKB7JLt7x6+h8uRXsJcjVSQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:4188:0:b0:703:2633:87c1 with SMTP
 id o130-20020a254188000000b00703263387c1mr3074882yba.132.1673474125182; Wed,
 11 Jan 2023 13:55:25 -0800 (PST)
Date: Wed, 11 Jan 2023 21:54:21 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230111215422.2153645-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v2 0/1] Replace MAX_SMP probe loop
From: Colton Lewis <coltonlewis@google.com>
To: thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com, 
	andrew.jones@linux.dev, imbrenda@linux.ibm.com, marcorr@google.com, 
	alexandru.elisei@arm.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

v2:

Instead of deleting the probe loop, replace it with reading QEMU error
output.

v1:

https://lore.kernel.org/kvm/20221219185250.631503-1-coltonlewis@google.com/

Colton Lewis (1):
  arm: Replace MAX_SMP probe loop in favor of reading directly

 scripts/runtime.bash | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--
2.39.0.314.g84b9a713c41-goog
