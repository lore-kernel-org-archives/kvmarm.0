Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA78E1DDF8
	for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 14:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xMngxZBC"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5af592fed43so48182667b3.2
        for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 07:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698762657; x=1699367457; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G+5mFSmwzy02eXplSCzUEvQ6qF9l0j94is7Nf9C9jYY=;
        b=xMngxZBCrXlDIIqnJ1LvOddn9a93Gz5+0D1Dvw8hBveOsV1mTvj6+a0OpLMjTvcMgu
         whOUpmlJDc04qQV0KWUyBWbuAbQfVlAA8O8PAaVEby8cLxgZsECvPPAYUhsa2zls4pqT
         jME55w3QRRy4gmjeboVwRfTBPYRhivcHqMRRqt5uVBa9nSwNezzpU6HZqo/+8ass9YvP
         CFY2tPUSk/k4TPqUDcXaCfb/OkDlFghzYXGsTiR1SikNNnnpQ/d8nC3zdfqojYSHBBo7
         F1P9VQalcYxuImnXhD7733Q0BAuk3CpwNc04ZfgDWPvLJ8HLAZgcseScL99hs0f9veN7
         CO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698762657; x=1699367457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G+5mFSmwzy02eXplSCzUEvQ6qF9l0j94is7Nf9C9jYY=;
        b=RepK+YfKKbkJIyOlITPRmf/IuqWEcbklQA1Dtj3YoY/otkoHaINahMhd9XI9Un5r15
         k9tmPIk0BcXZC0oK56JkcH29a6cZ7qCKywM1uCMM/rKjwDy1BwdCLRtacm2iHcMGJ2qC
         f8SZYu+kexGQY5XOd7IEi/RUL7Ak98/Ma5CqKHjqettAsSqzGmkeKIhOm10oEEdzwJ0D
         Y5O4nldZ6dhITIDknlzivvjUyOxrP+PqO+GphQ+zsPJ/rEWQY+Sj3TjlkXl9S+yqI3nz
         liCrq+KEqM/Hy88wWvvrmdxy3UsBx+FRWvh/KBaRiN0SAq5jIDx9F1cM5xRDxhukDRoH
         nnqw==
X-Gm-Message-State: AOJu0YyuU7OM6iIq9RXstrQVzppKZtvn3id3wS9ue2hXiFm9byoTDsHE
	1agqYxNEO52KCAc4hji74ACx886X0lY=
X-Google-Smtp-Source: AGHT+IEZqhN+IYUKaMtos7FbgKMZPVomc9IftVr5HCPDZa4DCVZQBFFRA7mieVnbr/UJ/ajvGhyuR5QPPKc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1788:b0:da0:c9a5:b529 with SMTP id
 ca8-20020a056902178800b00da0c9a5b529mr222465ybb.12.1698762656758; Tue, 31 Oct
 2023 07:30:56 -0700 (PDT)
Date: Tue, 31 Oct 2023 07:30:55 -0700
In-Reply-To: <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
Message-ID: <ZUEPn_nIoE-gLspp@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, David Stevens wrote:
> Sean, have you been waiting for a new patch series with responses to
> Maxim's comments? I'm not really familiar with kernel contribution
> etiquette, but I was hoping to get your feedback before spending the
> time to put together another patch series.

No, I'm working my way back toward it.  The guest_memfd series took precedence
over everything that I wasn't confident would land in 6.7, i.e. larger series
effectively got put on the back burner.  Sorry :-(
