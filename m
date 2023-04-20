Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5702C8F44
	for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 18:10:09 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-3f09b9ac51dso26032605e9.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 11:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682014207; x=1684606207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3tTimXPUFA+X0/aMlpW0bIFSfqQCXvrIyP+TzAV0QAo=;
        b=J/1WiSoVaU2DeuE5CeLf4PUd0lFh1qEauGbEPR7HSYPZP3YI3ew9bTozKNbfEOZlW7
         ba3rr35yW6hfetch9hQM3LPdo4yiWkc7dkvam5YpaaBhCf9fM68Jwmyost89XkXZG/j4
         AyIOFhcWask2UqKAd2+aubHZ7VAUhSmXen18eXlFriSsccEqG+Tw3zN1avvUjF3RSgmv
         3A5pKA3I2qREx2N2gAPFJ86R6MsvozfFglYg8e9KO/5ptyQZkQQSdAQOVaY5T9hM93pW
         +bOz0Ypt9PoASs0/GtmuSQWBqv6gPNfJJWNeaHWQGcLItdyZWpKshWLX5g/swUCT0Qmb
         mWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682014207; x=1684606207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3tTimXPUFA+X0/aMlpW0bIFSfqQCXvrIyP+TzAV0QAo=;
        b=jWEK0I6qxUbCOh/poEJ20rMEHRpkzdvhjzjViASi5vK1ECtF3toRnd9ZdsAYw5h0K+
         bZr7d6pRfCMacqhU/Q+5fvJ/DervPJ3JEMSbwgVk7vbBv221j0dsUUBQKatYauQEphss
         ERRYpH6nBKEpEtehLH+1uGoqcvcQ+WQIbM26aE3b4RaTCfrjjFypjPeYJ9Y+/GEr/uGD
         qCYUqNbQ1qe92HcsjsxJUNOYtqSS9dj7fvw5dMDHRGIrbEZ8oTz6Mymv9YbO1Hzzt/JY
         Df1xow4lg2Fu9zqFBGiqPM7KjMg+frRQAz/goVkmQj0Vo8D1Q95cri536n5YQHD8VcIv
         dGHQ==
X-Gm-Message-State: AAQBX9dGOI2v9vlpD1wYb5QQnHt1inmvKYUmpdj467IEt0wt8JxOztrt
	PDLIt7rx9R1IAOj02BK4Z8gzpNIDbD6sHItpM7WXQg==
X-Google-Smtp-Source: AKy350YKmxmoghfij+pf32r0TBd/PBCk7J+ihUx7vhnJEGhBVYhIkPHhwvgFKI4Fv9Wnde3u6LgsgQHuzVzSB7fXiiM=
X-Received: by 2002:adf:f3cd:0:b0:2f5:9146:7024 with SMTP id
 g13-20020adff3cd000000b002f591467024mr5898472wrp.22.1682014207340; Thu, 20
 Apr 2023 11:10:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-6-amoorthy@google.com>
 <a518e669-c758-57c8-3ba9-b4844e2cb79d@gmail.com>
In-Reply-To: <a518e669-c758-57c8-3ba9-b4844e2cb79d@gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 20 Apr 2023 11:09:30 -0700
Message-ID: <CAF7b7mopmS5dQEQSC4g5NVmDpfV7UJv2UursruROrr3kb=BQHQ@mail.gmail.com>
Subject: Re: [PATCH v3 05/22] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Hoo Robert <robert.hoo.linux@gmail.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 6:57=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
>
> kvm_populate_efault_info(), function name.
> ...
> Ditto

Done

> struct exit_reason[] string for KVM_EXIT_MEMORY_FAULT can be added as
> well.

Done, assuming you mean the exit_reasons_known definition in kvm_util.c
