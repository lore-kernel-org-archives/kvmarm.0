Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E071101E1
	for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 04:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="c5KpglIR"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-507d1cc0538so7213127e87.2
        for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 21:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1698726633; x=1699331433; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/zl+WazKFc5HhMN50LZss0tyvIWhNvX+UxT2FffeptI=;
        b=c5KpglIRqTMk4I3frgbXEaI1Q8pq9gq0SbVszfmvORF6pQwrMmxvdkR+R18bd0i3+A
         /1o0CMOPAnEcsnvTfBp0PYf4lDkZadpM9NOilayuhLMKpHb+K0cywzbySVYtiPyvNPZY
         d5X2D2OKzu7ZxxO7rx04areRvzs9aGheutXEA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698726633; x=1699331433;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/zl+WazKFc5HhMN50LZss0tyvIWhNvX+UxT2FffeptI=;
        b=w/AZI1MAe+1MD2DrkZmoKnrKYzsW4yUa2MYmyKHdN2POFOpHsGhycpMjsgiCzdnGcl
         7HmVOGfJrKZ4tz4ClwZCOFp7s9wnM13KuobdV+hYNWjU/fXBr6Iq0ibWVqasaqLJxo57
         r5GNCogWgCOYuSgeQp5e9W6dJpYhTuwWOdIk5dWNuKMmUMg77uuGpXaGr3VRvzff21T2
         tXsc4s2rhSSD+q6k7qiM4kAQQleN4sCAi/n4E97854pTUIeUDMcsS5Qw503eVtslb1Ws
         T7m16zTFBapgRHtQ/uEN5FixAMckKDeJOV6NhWp6Wc3OiVrJawyM01Sqa+bmwFrTXUBy
         V2tQ==
X-Gm-Message-State: AOJu0Yyt9lvxKAJK/rbNURirKJrzB8X33O+XZnpYs6UYgUTnNGFxRsEs
	PJmCZYhY21pbqY58l4N+DG5KqknKC5EW6DuJB8t+2Q==
X-Google-Smtp-Source: AGHT+IFkFMOcoKydhMu+wv2rhPuSAm4i0gRv+cc6pol6A8loPI1tW7TBI4rukvH4Ja1NFYXKJiMdHv7K9smM18sVk1M=
X-Received: by 2002:a05:6512:48c6:b0:507:9fa0:e247 with SMTP id
 er6-20020a05651248c600b005079fa0e247mr8045647lfb.32.1698726632783; Mon, 30
 Oct 2023 21:30:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com>
In-Reply-To: <20230911021637.1941096-1-stevensd@google.com>
From: David Stevens <stevensd@chromium.org>
Date: Tue, 31 Oct 2023 13:30:21 +0900
Message-ID: <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sean, have you been waiting for a new patch series with responses to
Maxim's comments? I'm not really familiar with kernel contribution
etiquette, but I was hoping to get your feedback before spending the
time to put together another patch series.

-David
