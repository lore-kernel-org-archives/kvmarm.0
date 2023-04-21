Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE83A5670
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 16:22:10 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-3f178da219bso19708435e9.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 09:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682094129; x=1684686129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrYsNtgw74ztN7e3pvnyx/JwXWQAkNxk8bJ7YuN8gRw=;
        b=19P5qaQDD6Ir4qwcHLjD1JpIvWPpQH6x+LtIKYqRaa+8XtTyn5d1fWxl7foPysgIMt
         pzxBPWwJHKRLEEdXgOr/LCSqciy/szp5DwfCWCX/c//f8kqBoGYNuH9IfD0ewCxh7YCT
         owqAxrNvM/wufLhAfp200YLkcUVqmPV6sf5bbe04iIXMUEEjgGscfnVFcMTtiIrsb7As
         k3/2XcbvHRIpuPbtDxSlVQBkd9R9C9CoFLV6qOUM4USFJCoQ/ZGEMJ9EJ+7jhO9i3jEZ
         NOl98CeqvMKRZad4MnenhhK38PydTAGe7lQiBDsI0aTkZ3zE4JUiOntaj0eIZ1zaaJ2K
         3qHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682094129; x=1684686129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GrYsNtgw74ztN7e3pvnyx/JwXWQAkNxk8bJ7YuN8gRw=;
        b=CuSd7GXRj00dEGnq/xJM/aCa+ceRTfgG0SOJOtqvUIrutar4UIwqyxid691A9Nd07o
         GwiP5xdffcBTNaPdWe/pKMR6XE4Z6KoeQ0GKsPiBWIoLsbigECc2jO4BNBweKCYcsEAi
         KRUIIVJWeqmfK+h5fBh+yFeUucPBf4vIGUOU5yOXIvtWeWY04S0cXEkLAe1jJh7+QMzu
         6zMDKVdfmsSw35KChUf5THtJT0oEiu85tN3CPiAdB6pWzxfgu/9xok767F4v8MJicTNM
         NaHgzpHyZjMi8NdSpC3JlmzjRhRSlx1zLoQwKjZ5K5Eb+gwRCM0hjwYgc9giAVDg3xzO
         3CXA==
X-Gm-Message-State: AAQBX9cm6MD4i6/aW9Nj4viAviDh6aLKE8k+iPR+l3lx/3AyrvPh8rW1
	KimheDTqQTQqiY9nj1vdhStpxUoovAcdhCImwAqqjw==
X-Google-Smtp-Source: AKy350YOOW/R09AMwTETRErtw1r2/Wun0ysqRNAv+E7XGPitF9a+Jc7pmelyd9j7FsmyFQSzUDUOVyUJzBF+0pPDXBc=
X-Received: by 2002:a1c:f30e:0:b0:3f1:6d22:eaa0 with SMTP id
 q14-20020a1cf30e000000b003f16d22eaa0mr2643410wmq.2.1682094128700; Fri, 21 Apr
 2023 09:22:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-2-amoorthy@google.com>
 <e73e9a97-3c76-fa71-b481-c0673e8562de@gmail.com> <CAF7b7mqMhQmQzJEhZJvEXGUzFB=jSXXOQUr22=Ef+oT-EDyEkg@mail.gmail.com>
 <CA+wubQC0rqteeDdU04vhWahBiwTU5ty5V+pTUXGYu9xd4ppM0g@mail.gmail.com>
In-Reply-To: <CA+wubQC0rqteeDdU04vhWahBiwTU5ty5V+pTUXGYu9xd4ppM0g@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 21 Apr 2023 09:21:30 -0700
Message-ID: <CAF7b7mp=f3PEfsC0+1QG9gOXDiZ-P+jX7XeX+49f+KgTmWS1NQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/22] KVM: selftests: Allow many vCPUs and reader
 threads per UFFD in demand paging test
To: Robert Hoo <robert.hoo.linux@gmail.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 21, 2023 at 5:15=E2=80=AFAM Robert Hoo <robert.hoo.linux@gmail.=
com> wrote:
>
> IIUC, you could say: in this on demand paging test case, even
> duplicate copy/continue doesn't do harm anyway. Am I right?

It's probably more accurate to say that it never happens in the first
place. I've added a sentence here,

> > > > +             /* See the note about EEXISTs in the UFFDIO_COPY bran=
ch. */
> > >
> > > Personally I would suggest copy the comments here. what if some day a=
bove
> > > code/comment was changed/deleted?
> >
> > You might be right: on the other hand, if the comment ever gets
> > updated then it would have to be done in two places. Anyone to break
> > the tie? :)
>
> The one who updates the place is responsible for the comments. make sense=
?:)

Fair enough, done.
