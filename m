Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C011181A
	for <kvmarm@lists.linux.dev>; Tue, 12 Dec 2023 01:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TN/LWXBi"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-50bfd8d5c77so5925762e87.1
        for <kvmarm@lists.linux.dev>; Mon, 11 Dec 2023 17:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1702346377; x=1702951177; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQ89ZIrgto37G/xlhKf3Jw+2Aq+MN68zNYm03Mdawcg=;
        b=TN/LWXBiwBjdFitAhqbCKBV6PEu5gYT31rf1YFjIHt4L0N4EXShSUEFC2WJzlo5NCe
         MNQhE5MY7s3KlfJZIqNUkytWOyoQBARZbzJ6dd/iiE/c5VNoOvtcRK2xuKdSjyLOz/Ml
         6kJEOPl4lvoNv25akRZXW2B5mxPNtCalND0Bg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702346377; x=1702951177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uQ89ZIrgto37G/xlhKf3Jw+2Aq+MN68zNYm03Mdawcg=;
        b=mIdlGNGy0iACUlz+AaMPJqInFVkA+Tj/vZMkcLEGXDfk+cqpFaLSs25Ufy3ceIusMO
         zKXBfFCKzIiwg308EjH1DuGwXp9bMU41vvnyPIITm8i8e+TlnqrwwuEJpD6TxdOFV6rY
         dYpLgccVasKf1suZrIsyLPUeQvwJGBH3218GDttQp8ZQVB6Pz/UBivoNc9iSRrSXhM74
         RFCgOCtxgikMkfwYGDIfPb/167xVmQVx2izAH3I7uodZTG641TyIab4Jd0O7dKfw2hNV
         To7NOMUhVat3xaWseEJkapiVHVrVx684CD74fjanOWWGvXYEv2uyp7nduScPYa2rJ7+e
         i9OA==
X-Gm-Message-State: AOJu0Yw9v01+YSj3JRUBc18E37atUBEMinsnzmdlHqlxuzwn3BEd2um9
	tg8jIgO4UdprXBmshMwEzsbJQcmSzkWyeO18YIxX4A==
X-Google-Smtp-Source: AGHT+IFPkMwM+ODEL8jAac04JHQ1iWXAbY+dSF92QrVLp74yCwtnOhjG/2NaE3hAxNkItRtrSNp0Jef+ghFheIRqHhQ=
X-Received: by 2002:a05:6512:23a7:b0:50d:1a10:d27f with SMTP id
 c39-20020a05651223a700b0050d1a10d27fmr1444302lfv.201.1702346376180; Mon, 11
 Dec 2023 17:59:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
 <ZUEPn_nIoE-gLspp@google.com>
In-Reply-To: <ZUEPn_nIoE-gLspp@google.com>
From: David Stevens <stevensd@chromium.org>
Date: Tue, 12 Dec 2023 10:59:25 +0900
Message-ID: <CAD=HUj5g9BoziHT5SbbZ1oFKv75UuXoo32x8DC3TYgLGZ6G_Bw@mail.gmail.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 11:30=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Oct 31, 2023, David Stevens wrote:
> > Sean, have you been waiting for a new patch series with responses to
> > Maxim's comments? I'm not really familiar with kernel contribution
> > etiquette, but I was hoping to get your feedback before spending the
> > time to put together another patch series.
>
> No, I'm working my way back toward it.  The guest_memfd series took prece=
dence
> over everything that I wasn't confident would land in 6.7, i.e. larger se=
ries
> effectively got put on the back burner.  Sorry :-(

Is this series something that may be able to make it into 6.8 or 6.9?

-David
