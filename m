Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0A22F43
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 12:28:38 +0000 (UTC)
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-74e3c84e689so40685385a.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 05:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682080117; x=1684672117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LaA2IxjFzdB4pL6Hvh4e5PWI3DFz5C3NfZLvof2RS6A=;
        b=CfrWzaBJwLGlpq2Gqmthv22Pig8tuTHuNDHAwh+Zwb35qvZ9Tw/barFCYvaCT/GTNO
         yD96aXapUnJ3gsbmNB0YC2mWV/gcrBeIW3Ed/6K8PeT+fekkOG9TLF/FhOCHgeMtVU65
         nRlMSgUZkio33xAqsOGrBe/v6Lc9GIIoCKctOgoYKS5g9Voz02LdJ5BLxOPWUY7oMNMZ
         IpppfvrtCiW651UQ7JA7LsJUpgixgczrcnBYq+0FgJDBrvkgq+tYA/R52+k3FQGMIpwM
         ticuqGxj+QynHWT1IB3fIYdj+EHQ+wkU2xws491CPNeb+DfJVLZWflTpMv+UhKKYS9B4
         //8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682080117; x=1684672117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LaA2IxjFzdB4pL6Hvh4e5PWI3DFz5C3NfZLvof2RS6A=;
        b=Qqi+BpUDWqoKETdfXE87A+ij35bpzeO7BwrbSMNPDmnK9OyOdgKv7b0Xmk5KyhTupx
         9uogLRx+cQxnpuJnkx8FtqxpUWkDYVJZnyhbRuXynGFMhccC2sMcN/L8iAsuiktfQyM4
         80qbotPur1+NP/e05qmkyZTvA23AinbRQQ2HQPz+TItFfvEe2J/x793a/LDDcU89Fngl
         t4bRSijeL7uj/34ttSQk9EvQJsanEhDX8ph0W9dzFT8jxSMC7HGwGAx0QnsHJ4zukuug
         sTTIiNcgr37eRONq1+eYiScmnKmuhtsOps7MgvK0R01wh9GoFP+pepszeQqyjFNwAhQy
         Lhug==
X-Gm-Message-State: AAQBX9dkt0XAIevum1yfG6FBbvDKU5fFKKfLXiT3dPWt7XaH7ZBxHa9j
	R/T3XiFgsodplLh/2a0rtIR2XYkFvO30g+EDEs4=
X-Google-Smtp-Source: AKy350Ytf21NwN1nkXRDtNVotBxyI5dApyXftcbFhG6ouEugUyR9diFOOTcR/HxPw0BIZw53qTagDEJw9DpAtQZP5b8=
X-Received: by 2002:ad4:5f0f:0:b0:5e9:9eb:e026 with SMTP id
 fo15-20020ad45f0f000000b005e909ebe026mr8473624qvb.29.1682080116952; Fri, 21
 Apr 2023 05:28:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-6-amoorthy@google.com>
 <a518e669-c758-57c8-3ba9-b4844e2cb79d@gmail.com> <CAF7b7mopmS5dQEQSC4g5NVmDpfV7UJv2UursruROrr3kb=BQHQ@mail.gmail.com>
In-Reply-To: <CAF7b7mopmS5dQEQSC4g5NVmDpfV7UJv2UursruROrr3kb=BQHQ@mail.gmail.com>
From: Robert Hoo <robert.hoo.linux@gmail.com>
Date: Fri, 21 Apr 2023 20:28:26 +0800
Message-ID: <CA+wubQAvt4UxvJV17hx-V-93cH7Wz0cgGyEDbu90gD0sOsCHMA@mail.gmail.com>
Subject: Re: [PATCH v3 05/22] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Anish Moorthy <amoorthy@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Anish Moorthy <amoorthy@google.com> =E4=BA=8E2023=E5=B9=B44=E6=9C=8821=E6=
=97=A5=E5=91=A8=E4=BA=94 02:10=E5=86=99=E9=81=93=EF=BC=9A
> > struct exit_reason[] string for KVM_EXIT_MEMORY_FAULT can be added as
> > well.
>
> Done, assuming you mean the exit_reasons_known definition in kvm_util.c

Yes.
