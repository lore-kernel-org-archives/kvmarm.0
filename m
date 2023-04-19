Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDC7320C
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 23:26:44 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id he11-20020a05600c540b00b003ef6d684102so2234034wmb.3
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 16:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681946802; x=1684538802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tPEpl165mfYvy9T7s6K/AOw86FzBzrStc3Zob8MFFuc=;
        b=om5ZDWcpQHhZivxtfcJiW0+S6OuX9kPpTw9FcDnas8O6UirVWJ57HimdRJaSMMsvnt
         m5caIkfbLvFQcAadWubhwR6Ua9HJ7DbcGNK/pDXxJhFqSgNowchEUSMvHlbHiflnMGCT
         ZjDn/kqdX2/5gf7Se9GAIQHXqf1u33EO5jo8MHiFz9TEHJsWdubdibG4FJEi4+7w0enR
         +sNGkItAVqMKdsxrWTYwU97cTriqKit8kiNPNk7sPNzysuAzVAPESuB5Z042xhRKq/jP
         gj6MlRWWgFBqJ1OBTkwzJXjSpsRe3H9+SbzRJFEZB6+vzz9wUGXIhriCAjvKMLpZBRU1
         V6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681946802; x=1684538802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tPEpl165mfYvy9T7s6K/AOw86FzBzrStc3Zob8MFFuc=;
        b=OuUYlCH+inWpLV7iCwKMMRu7rZUC8GBgry5d8EJTVKoyV3z0c8Fe4Rz9Iu8rp+4sC/
         4k8eQBpjWZdWX6rcgYNpM5KK73GpaJ8Bv3TiYglmBA9JcxAeAGhDO1WV88UuM0ps8LCw
         /h6U+4Eb0FKLFCawiUNa57+NMT28YhDdUA/YSY5tQPNkyNtJlw63fwCn5ZSsrt6hkSWc
         to13JJ6IW/LoOL8rCeZLKk582e/IX4le2BP3+DWbidZaEVaIe3F4C8wZddBYnoJC/5xu
         3EHkad1JSGZQ0BfsQW55iZDunItomSz4hhtMR2TmXlZfz4x7J+VW72YJAJ3TV49GZve+
         lOyg==
X-Gm-Message-State: AAQBX9fvaZQcATUkNxeykOFU7rBEGMVjpbg+MDAzLO3JuUH+DxaZ2bLy
	sO0Y+z5DjAIvKNKnNh2EmLGCea7pX+MJGgV6Jueopg==
X-Google-Smtp-Source: AKy350aGgjiad/WfnyK+DyOn2eUk1ngiL9OPNmn0Iw+laUeHPShxAtPDZHc9saeNfFGGYcThkWWxETPyg/vvgCqDj1U=
X-Received: by 2002:a1c:f402:0:b0:3f0:9f44:c7ce with SMTP id
 z2-20020a1cf402000000b003f09f44c7cemr17828816wma.22.1681946802599; Wed, 19
 Apr 2023 16:26:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-3-amoorthy@google.com>
 <a43e5deb-211a-c4c0-6b1d-7715c3665017@gmail.com>
In-Reply-To: <a43e5deb-211a-c4c0-6b1d-7715c3665017@gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 19 Apr 2023 16:26:05 -0700
Message-ID: <CAF7b7mph_3gtYc=EEJ4fiVLZHRPUpSUY5eYzTsitdXG=pu_1kg@mail.gmail.com>
Subject: Re: [PATCH v3 02/22] KVM: selftests: Use EPOLL in userfaultfd_util
 reader threads and signal errors via TEST_ASSERT
To: Hoo Robert <robert.hoo.linux@gmail.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 6:36=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
>
> How about goto
>         ts_diff =3D timespec_elapsed(start);
> Otherwise last stats won't get chances to be calc'ed.

Good idea, done.

> > +             TEST_ASSERT(r =3D=3D 1,
> > +                                     "Unexpected number of events (%d)=
 from epoll, errno =3D %d",
> > +                                     r, errno);
> >
> too much indentation, also seen elsewhere.

Augh, my editor has been set to a tab width of 4 this entire time.
That... explains a lot >:(

> >               }
> >
> > -             if (!(pollfd[0].revents & POLLIN))
> > -                     continue;
> > +             TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
> > +                                     "Reader thread received EPOLLERR =
or EPOLLHUP on uffd.");
> >
> >               r =3D read(uffd, &msg, sizeof(msg));
> >               if (r =3D=3D -1) {
> > -                     if (errno =3D=3D EAGAIN)
> > -                             continue;
> > -                     pr_info("Read of uffd got errno %d\n", errno);
> > -                     return NULL;
> > +                     TEST_ASSERT(errno =3D=3D EAGAIN,
> > +                                             "Error reading from UFFD:=
 errno =3D %d", errno);
> > +                     continue;
> >               }
> >
> > -             if (r !=3D sizeof(msg)) {
> > -                     pr_info("Read on uffd returned unexpected size: %=
d bytes", r);
> > -                     return NULL;
> > -             }
> > +             TEST_ASSERT(r =3D=3D sizeof(msg),
> > +                                     "Read on uffd returned unexpected=
 number of bytes (%d)", r);
> >
> >               if (!(msg.event & UFFD_EVENT_PAGEFAULT))
> >                       continue;
> > @@ -93,8 +89,8 @@ static void *uffd_handler_thread_fn(void *arg)
> >               if (reader_args->delay)
> >                       usleep(reader_args->delay);
> >               r =3D reader_args->handler(reader_args->uffd_mode, uffd, =
&msg);
> > -             if (r < 0)
> > -                     return NULL;
> > +             TEST_ASSERT(r >=3D 0,
> > +                                     "Reader thread handler fn returne=
d negative value %d", r);
> >               pages++;
> >       }
> >
>
