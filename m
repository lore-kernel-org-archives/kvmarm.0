Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAEC7464
	for <kvmarm@lists.linux.dev>; Sun, 25 Jun 2023 19:22:28 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1b7db2e162cso4873345ad.1
        for <kvmarm@lists.linux.dev>; Sun, 25 Jun 2023 12:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687720948; x=1690312948;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T23wHrD6vv0yTBZS/6TP5/IeWklyAPQCYvo/tKPMvz8=;
        b=R+suup7aKAuk1Sdcl69iCPuytMTS4fc5strgidUDEWZebhsw6evA7tXzP/2h7rScR9
         /Q62d4HayRO83gB+XqsZ+WX2siypsGa6v+G7MdzhjPibILSoax/ELpnlSrchUpHdnC+c
         AXspjhsuw7yk7sUTToymf+QA+ULzaaZldyYRQNKCBx6srQCdhbgFqf1LrfVY55Hmamzk
         edMm+m8YcTvumDXwtJ7DeJrPOmEubcdd19MtWC3p2MUNO/Xft/Is+0WWr+7IbI+IaJ1x
         RkGs2NALCEqkJfpB9WsLx/qEEFVjQTGcZu8sAthTSt3mcQAXzYE5GYsPZgxmSx29wW+O
         BOFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687720948; x=1690312948;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T23wHrD6vv0yTBZS/6TP5/IeWklyAPQCYvo/tKPMvz8=;
        b=FQ9RNZNUXpJ55KvHZntbm3G29o06Th0EGBGkq1ikPHpmNmz/rvHSxSyV1stghQ4fW8
         BA2ZzI7kmIz99YXcWbBsYbJuBNT2uma9Hr1PT1fhYIwESFnK5Ko61dG81iEaLKD3Gh7l
         VPk15cO4rF8hVL3pYLg7JEKXjsD1WohT4cA00zQUmmAKsP28ikXJ20FBYobmMbDFQTSh
         AzqTHXrjc8YX/9/qW4SPTY2AV5fmu5pOsof4oaXj5oWZ1/VNCERCq80XT7sagKREF/0R
         Rp7ecB0UoX0zcSfdXt9dCPNHlWQDQupbWSPtgV5U9i+QgvGimav4xGQsT7NYCH4bsgCC
         tmPQ==
X-Gm-Message-State: AC+VfDy6TffbDJj3jc18OFt0aWgPKM1NX1oWzPIaWAWkldbXquK6PG1m
	wfFjse7P8DfLIs1q91zgo+8=
X-Google-Smtp-Source: ACHHUZ7o5CnXU0LWpABDecVTJF5gdRiruxvkNBe2aSrqBTlpM2weAfpO0PHMhj30xNGAgbnnz+LB/A==
X-Received: by 2002:a17:903:18b:b0:1b5:2c0b:22d3 with SMTP id z11-20020a170903018b00b001b52c0b22d3mr3715872plg.14.1687720947675;
        Sun, 25 Jun 2023 12:22:27 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id k13-20020a170902ba8d00b001b69303db54sm2766440pls.91.2023.06.25.12.22.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Jun 2023 12:22:27 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH 3/6] arm64: enable frame pointer and
 support stack unwinding
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230623-622ec2c26e09f951f42cce46@orel>
Date: Sun, 25 Jun 2023 12:22:15 -0700
Cc: kvmarm@lists.linux.dev,
 kvm@vger.kernel.org,
 Nikos Nikoleris <nikos.nikoleris@arm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7BD2B564-E0E0-4589-8FB1-E82D5D697D13@gmail.com>
References: <20230617014930.2070-1-namit@vmware.com>
 <20230617014930.2070-4-namit@vmware.com>
 <20230623-622ec2c26e09f951f42cce46@orel>
To: Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)



> On Jun 24, 2023, at 3:13 AM, Andrew Jones <andrew.jones@linux.dev> =
wrote:
>=20
>> +extern char vector_stub_start, vector_stub_end;
>=20
> These aren't used until the next patch.
>=20
>> +
>> +int backtrace_frame(const void *frame, const void **return_addrs, =
int max_depth) {
>=20
> '{' should be on its own line. I usually try to run the kernel's
> checkpatch since we use the same style (except we're even more =
forgiving
> for long lines).

I usually do use checkpatch. I guess I got sloppy. I will fix these 2 =
issues.

BTW: I used the get_maintainer script to get who to send the patches to =
and it
included the depreciated kvmarm@lists.cs.columbia.edu =
<mailto:kvmarm@lists.cs.columbia.edu> .. Ugh.

