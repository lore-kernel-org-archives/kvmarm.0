Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0557946F
	for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 22:47:41 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3f17fdb520dso10915575e9.3
        for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 15:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682030860; x=1684622860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I500wf29ShVTt/8kNXae6cb36NI8eexo7GrOocU/WMU=;
        b=IzlePHjF/qbChziTFLQN+LJ+aTmnw52wmdpyTv2kL0Q6NG/AyPO1+HnzacS7BWyViR
         pDE5N0vbgaHydiw7YYYTH4t4x15EHkEgR/eGyjZ3EJHkGn9rep5mViODsGV1QHBsDrSR
         ic+7OUcSUTfa1LkYLGX+EKMTxg51Gl0A3tltVxWIen3yafNjK6h6XR/D5kYMB66oGc+H
         e+rSrr0Tg9RP9DpJGFC3d+JukTOjaqFisiLC/x4+EXi9vIUiZ8aCq1KShJ79r/3Khsik
         5fW3/+LypYYbUUuJ1pqKWUd/CEug0j8xLPdFS+dXaTJLMjZLIMk/OwYy8/TSOEeFyZUN
         4cDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682030860; x=1684622860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I500wf29ShVTt/8kNXae6cb36NI8eexo7GrOocU/WMU=;
        b=Ft+09IUZAcy2DTmjaRsmT/h2hEERNHDt78OHVUXAOy7lgEsgWhfsQtkEij6g1RMXs8
         Nqdop/EJ+3u5O3FpfRL6ghenCv8DZRxHA0ZVEYb5XrK6GLtY9mRR5e5I/uR+rU+VTB4S
         91Vew4Pj9Nlq4zmkXpy60lT1atgyYGB1/sqI/qaESfz+3X0mG2+OwOY41krpBEcQgNqt
         jbuD5kkYbz9CydhzglhYHTlzEPc9IyVRpIb4AEtmLra2u4p3W2fqURio31N6XnXBrJNf
         78pX8qe1PQJ1UqtYO62DGDFqe7JU6xUVPkbxAnPdCUsQf/4aSrC4RmL3BuKx+t/2QZHv
         r9TQ==
X-Gm-Message-State: AAQBX9eyCM2mkHiat4b0kHku/VufhVGu+rEZArZ96t5nNm+CcP87JKim
	CTQgixjJ2K3i8eHJKVkok+PSrga7+UXTCiCjcyKl6A==
X-Google-Smtp-Source: AKy350Z/7sBVzla3WvehW8q8Z1Pvmrks0DHxOdhv+P7CBhhNPJPBZ4RwV7tyeJqUXZTkzE3xfbV9xvVD5eqjL5iRCwY=
X-Received: by 2002:a1c:ed15:0:b0:3f1:6fb3:ffcc with SMTP id
 l21-20020a1ced15000000b003f16fb3ffccmr338953wmh.22.1682030860171; Thu, 20 Apr
 2023 15:47:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-23-amoorthy@google.com>
 <7db5a448-f3b2-2c43-1cf1-d7e75e8d06e1@gmail.com>
In-Reply-To: <7db5a448-f3b2-2c43-1cf1-d7e75e8d06e1@gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 20 Apr 2023 15:47:03 -0700
Message-ID: <CAF7b7moF4p+f1sFVa+nYa+LqzpjpRqj7HV2eo3grE6mW0ppAug@mail.gmail.com>
Subject: Re: [PATCH v3 22/22] KVM: selftests: Handle memory fault exits in demand_paging_test
To: Hoo Robert <robert.hoo.linux@gmail.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 7:10=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
>
> I think this vcpu exec time calc should be outside while() {} block.

Ah, you're right: fixed.

> can this gettid() be substituted by tid above? or #include header file
> for its prototype, otherwise build warning/error.

Huh, not sure how I missed the warning. Thanks, and done.
