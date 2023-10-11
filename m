Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA3DC2DF
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 03:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X041fokF"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5333fb34be3so10760363a12.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 20:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696995631; x=1697600431; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Kb+3zqaQcMqQZMwRUDmn06YBTHO0A/ndW+8Em55WBrk=;
        b=X041fokFp8xgR6uqBbpfVWxqIJYSCv80cKSw7j9ZDr1mvYJIs7kv0BMiistMfzMrIk
         DHqim8Z5juBCyIhifu2nskBxTl8UCRokodl+QsUSBvCNCvKYppwTBQ6S2Mrt4q7dflPc
         6kGfDt8tgjZ3bjvR+NGEZ+98n+6T5Z2Jbitt2PCroTP2ttI6GgPqy8OUZaN/LIgygKlQ
         49BvKU2e6KbozsApAHnxQFqcX/xjMjtm5ug/fHY/nDHDhGcjyob+YBo9+fut9ThPvCtB
         8uPGrts49k1rqiszudKBtIzgZEk8EagsudwRA+EgBYJ9QIo3yAxPNsumgfUXv1YJLvA2
         c64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696995631; x=1697600431;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kb+3zqaQcMqQZMwRUDmn06YBTHO0A/ndW+8Em55WBrk=;
        b=QxJJKIqnLeCsNtLVTsuo3FZFX4Pqg9EF4RgMbq95BLibz5hQHNNs08lpuISRGCjDLs
         gcRKxOr37UrJftcsRMRO1J6rLvK/vEKcS5qI+rbUN7yAbc6HTz8OjhC7f0itO3FPqofW
         Wl5qH8tCWQH/wkz5B8U7Rlv6CMUTHxbyTy2/AxUb3KhdOYVXXoXci2Jb8FN3O6cCR0LF
         bafYT4tZf+Eh2RudI19kI4KOeXyyihcOMNsqVnIj+mgtZ53YMccWsu9FLiSpg8c5NSjL
         i7+PHGoXOyoomWGU3F9KaY0sT4whM+wFFJ1LbM5finpw+8m6kd7Mn7G1Iodn7jqeR4Tu
         UibQ==
X-Gm-Message-State: AOJu0YyLcJlDap6nXTkblPsn7HHwMiEKwk/cyRWGi6nE2/XfnziHmX01
	Y/9mPyEl/HJMsSePSD/BOsv/vf9+j48uQd3JA5fOTEj8pg==
X-Google-Smtp-Source: AGHT+IFYn5z4a4BYNZsmv2sv9J5Y+EY0yUHnHF4IvY8l+48ttsSeSq9eQN/6/fv9/CbMvIz76rnWRmjGO5fSzdYus60=
X-Received: by 2002:a05:6402:d59:b0:53d:e0cf:cb95 with SMTP id
 ec25-20020a0564020d5900b0053de0cfcb95mr103559edb.21.1696995630789; Tue, 10
 Oct 2023 20:40:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: KVMR <kvmrdy@gmail.com>
Date: Wed, 11 Oct 2023 09:10:19 +0530
Message-ID: <CAC=5qx_EDYCifRGNbXaJ96psuqQ-Y7zw8O_V_q-_kYpkuD52RQ@mail.gmail.com>
Subject: pKVM: Which kernel version has support for pKVM?
To: kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi KVM team,

We are interested in using Protected KVM (pKVM) in one of our
projects. Our goal is to launch protected VMs on Linux with KVM,
ARM64. We have a few queries and would appreciate your assistance in
addressing them:

1. We'd like to know which mainline kernel version offers complete
support for pKVM. We've observed that the current TOT kernel (6.6.rc5)
may not have all the necessary changes. Specifically, we couldn't
locate the KVM_CAP_ARM_PROTECTED_VM symbol in the code. If all the
required changes have not yet been merged into the mainline kernel,
could you please provide information on the specific branch or
repository that contains these changes?

2. Are there any additional changes planned for pKVM, and is there a
roadmap page where we can find more information on the project's
future developments?

3. In order to verify the pKVM memory protection features, we are
seeking readily available test cases. Could you guide us to where we
can find such test cases for this purpose?

If this mailing list is not the appropriate channel for these queries,
can you please direct us to the correct one.

Thank you in advance for your assistance.

Best regards,
Venkat
