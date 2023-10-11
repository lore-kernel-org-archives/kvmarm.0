Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BA939944
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 17:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d5tdNCCO"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3af5b5d7f16so28604b6e.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 10:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697046921; x=1697651721; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+qr3lgrcrbP/5gkIgkGNw3UMoeYR1RXB4GZuAt+u7kM=;
        b=d5tdNCCOrBtApEaOflgwhZdkGt6hSaRJ1x0nM4FWKIq6I9kusU7gVqGLiposgaWKi6
         MJ139VJtdJalAqp+FtXX8mlMeoM0kvAlk0K7tgx4y94wWXUwIAH/GhRULMgAFDk+aUZP
         EcqBWj65p9QI1ULz/CtxWVpF7i5q1O1iY9riQeeaC7chJL2jLFNXTCnlGxa3nues4fJp
         sQf5SC5S2XKGeAjZC4pbknr0ALQQdiOGU3uOxsh4eJ4jAhxhrdOH4eh7T/Z7mRgQ+bE9
         2zsLscRqGtXYT7q7wwfOND9wNCS+O4UfWVTgsihuZPd+CO7wWkHDax/CU5gJWKk5mxFR
         tBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697046921; x=1697651721;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+qr3lgrcrbP/5gkIgkGNw3UMoeYR1RXB4GZuAt+u7kM=;
        b=lBomSl+5yNj46b77pWUgFAS0Jkcyp8JHgVsQdMmylfRW73UIztTG4oImz3+YwHgFvd
         z0sRRcI+VjdrdKdoMYdzOiIin8BqiJTxj05SypixT/VZJ2/hvZknrCxJpszAb9+PJFLR
         ePzYBxhDedeEnmdPw19znYYkdVo4ejiNE+6ItVxQwFqQzUczhxKNa8qNvk4m9Pkj3jyo
         rFEBMgunijziNiQQtzr9CieHxnkE3bRRrUchytsbjXx5n/9WFKL8BGKDLf0eqoc1klII
         Vaqyu59pCKhii4och85uZTDNZfl3r1nKIVh6M2VMV8ypR37ijU0R3GcoL4e7T4AV2LUA
         mQQA==
X-Gm-Message-State: AOJu0Yx0Rfp0HtgA+Elo/Ngta5IO+ecFzXFyKRcsZd1eZkmt3+McB03s
	YVvriOApaIvxI+kJi3KgyXx3tmfqcmiBR/2GrC+ZvQ==
X-Google-Smtp-Source: AGHT+IH1xR3vjV99+M/LkuCERrf8FFb6dhrZO5dQtTRdGG7+xvAKomWG5ggluYGHUD3vZWhYu7IBXcl8FWzcBM1cD+k=
X-Received: by 2002:a05:6808:2897:b0:3af:d1d6:8a59 with SMTP id
 eu23-20020a056808289700b003afd1d68a59mr14716017oib.38.1697046921341; Wed, 11
 Oct 2023 10:55:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-10-amoorthy@google.com>
 <CALzav=f8YDdqxVXNRASNWxuM2WzgBwj=hErj1Yc5da552ecG5Q@mail.gmail.com>
In-Reply-To: <CALzav=f8YDdqxVXNRASNWxuM2WzgBwj=hErj1Yc5da552ecG5Q@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 11 Oct 2023 10:54:45 -0700
Message-ID: <CAF7b7mrt-iWduEQusKHhP3TLiWwL1gQjGj0HB=u1R2Vd5yEP0A@mail.gmail.com>
Subject: Re: [PATCH v5 09/17] KVM: Introduce KVM_CAP_USERFAULT_ON_MISSING
 without implementation
To: David Matlack <dmatlack@google.com>
Cc: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

> Bike Shedding! Maybe KVM_MEM_EXIT_ON_MISSING? "Exiting" has concrete
> meaning in the KVM UAPI whereas "userfault" doesn't and could suggest
> going through userfaultfd, which is the opposite of what this
> capability is doing.

You know, in the three or four names this thing has had, I'm not sure
if "exit" has ever appeared :D

It is accurate, which is a definite plus. But since the exit in
question is special due to accompanying EFAULT, I think we've been
trying to reflect that in the nomenclature ("memory faults" or
"userfault")- maybe that's not worth doing though.

Wrt the current name, I agree w/ you on the potential for userfaultfd
confusion but I sort of see Sean's argument as well [1]. I see you've
re-raised the question of the exit accompanying EFAULT in [2] though,
so we should probably resolve that first.

[1] https://lore.kernel.org/kvm/20230602161921.208564-1-amoorthy@google.com/T/#t
[2] https://lore.kernel.org/kvm/CALzav=csPcd3f5CYc=6Fa4JnsYP8UTVeSex0-7LvUBnTDpHxLQ@mail.gmail.com/
