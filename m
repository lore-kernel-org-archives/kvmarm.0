Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F21C8483
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 17:42:58 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id x139so637251ybe.13
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 09:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rJYcYZZzY+M9ZxHHejg1E8aKJPzOl0euqJrFocbUFH8=;
        b=iIf80nLU8eJ3TTcqZRbCLEoUWBCkv34wRmjU+y3ZuetcRNX82nc/RHWUyYfRwrK0iC
         Tm7y1M0H3avUtezwDYJHw00ncCGU/+yzS5GLazNozpF1L0L9xV/Fehr1ooTXz2/uXw4O
         xLuCAceRjd6g4+J1C7vpFly+Bu6q+yMahP7CSoGuwvo8p51Ji3H7KPu2gBjO4WZruzoJ
         gLZM7LJMfleKIU0cLxiRElhF3vpPQOTkk0naUn5AmqzYx4OBtWUmx4rLTGmzncKdCOv7
         PIu55CUtFxzZ8qlHp1C3Ysoye/fODeMRu9xvSSpquVQ8JftdiyvVj+gOCA4sUAzNeXIw
         lvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rJYcYZZzY+M9ZxHHejg1E8aKJPzOl0euqJrFocbUFH8=;
        b=zdetPqNO83sKowQdgDmEzr/M+0cvI3hWqZok6T8YiYr5XJgoW8VxzFzzl4tHCaiESD
         mudLcSXQramI60I02X81tgTl8r4cr3zGo2WruXdiWvy58ve+vZentHCMppDZN0h6Aaur
         rQv8QgEopGIHrjm9YZMhU99yBOe/j/3Z3vvVKn167KP/EupM40rI3YFzj4qeCW7B3XuK
         XTc9ULD6pnSdOovWeLrIpYWFPxOd4cl8LM7EBCPYk/taQZ8bYeBY5342jjah5pICRYUM
         09v1UQYynAxC4DiSs9b1chhQY9b649GBcgR0umk4b+DGmQTkgL30cigqDltYG9OWDEn5
         h/ag==
X-Gm-Message-State: AO0yUKX5FCux4Q7sVQzpv+Tqe6CO/wZYRx6oV0eUGitDZPPZb+gz6bAw
	wRgiS/b169f9tXOjgmdzua5xo30otNLhC+d+J07mNA==
X-Google-Smtp-Source: AK7set82FOp9DtIGRw89gONLvOwWzIz4Gt+lBD+BlbVec4y4ugm+6VEAO+bzHVj1GHH0KhNl0ZZtfsGm7jrLMLejvj0=
X-Received: by 2002:a25:dad6:0:b0:80b:ee61:e2d4 with SMTP id
 n205-20020a25dad6000000b0080bee61e2d4mr458698ybf.401.1675273377184; Wed, 01
 Feb 2023 09:42:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230201172110.1970980-1-coltonlewis@google.com>
In-Reply-To: <20230201172110.1970980-1-coltonlewis@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Wed, 1 Feb 2023 09:42:21 -0800
Message-ID: <CAHVum0f91JSkYexUMpNfk4STGAVL87y_xEin84K6LON8bieZVg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v4 0/1] arm: Replace MAX_SMP probe loop
To: Colton Lewis <coltonlewis@google.com>
Cc: thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com, 
	andrew.jones@linux.dev, imbrenda@linux.ibm.com, marcorr@google.com, 
	alexandru.elisei@arm.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 1, 2023 at 9:21 AM Colton Lewis <coltonlewis@google.com> wrote:
>
> v4:
>
> Remove last mention of awk and fix spelling mistakes in commit
> message.
>

Please provide each version's change summary with their links from
latest to oldest.

> Colton Lewis (1):
>   arm: Replace MAX_SMP probe loop in favor of reading directly
>
>  scripts/runtime.bash | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> --
> 2.39.1.456.gfc5497dd1b-goog

For single patches you can omit the cover letter (unless there is a
lot of information you want to provide and discuss) and just provide
any non-commit information after the first three dashes '---' line in
the patch.
