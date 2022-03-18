Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06E4C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 13:42:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0677049F1E;
	Fri, 18 Mar 2022 09:42:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ADmtfTr4w6ZW; Fri, 18 Mar 2022 09:42:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A453E40C31;
	Fri, 18 Mar 2022 09:42:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3B6A49E08
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 09:41:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YOuUy9e0MEiv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 09:41:57 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E0FA40B6C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 09:41:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647610917;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=DIbniuNolZexjaWhREmeAy3eBGSMYEukIAiBx0oi6HQ=;
 b=DGqlx3XtQlxSEF+hUtipVwQgp8agnhRxX9QHE1mUjW5pLJHOBpsEFbCPBJpgdJ3n6D+T1Q
 PBP3tCGivRneXyKoI5ZJ56FuIEg1diWmLLuM+QFxCF36QuHrkSENq9ozqA140hACZYDD6a
 FsVogPB9WjMJP/mliQdGf66ZyS6PSiA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-WLNXXpOoPjepL9USMMMXvw-1; Fri, 18 Mar 2022 09:41:53 -0400
X-MC-Unique: WLNXXpOoPjepL9USMMMXvw-1
Received: by mail-ed1-f70.google.com with SMTP id
 s7-20020a508dc7000000b0040f29ccd65aso4930665edh.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 06:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DIbniuNolZexjaWhREmeAy3eBGSMYEukIAiBx0oi6HQ=;
 b=suj/fIZRDqG2tfapyQM742Zqa9nWqyvT7CZF5GNN5K49kwvYviybq1bP4Md3rDFQoZ
 uRbycDY1j4IyBLixotbhNcp3PzCvOkKA/FPw0mbMyDslgBlm7p8JK/0NvRnjIUCS+3us
 8aKGJR3FV5RBndVux1NWnNUNkt8QWnQQNq5aIx3p23CxCLlGcpTzrOdKiFKOKy3MHvLs
 AfiIUhumUyyUsj9KqMCetjDrbbmu2WE1ElOzEBZ5D3HNhKBvKqhvqM2UC1u897smDUk5
 WmXqr2KhI0DmYs2jKBjgyualE5aUrZbyPee2vaBLk2kJYlOdcma/vs4Mx9KMPpJmHiRk
 7JGA==
X-Gm-Message-State: AOAM531jdY5amzHx3tHB899PZKXGJK0BG2J9FRxVz0KWMB/AwYTGHMss
 KrKjZ9uLmE+BBZjqs1K3JQgH2UnZia90DBCRU9ZDsg9GQiCHRRO8RcruLnyHvUjTAcKugLtFbU3
 AO0BSUb2x3IhN4afu1BYwU6gT
X-Received: by 2002:a17:906:1742:b0:6d6:c4f5:84a2 with SMTP id
 d2-20020a170906174200b006d6c4f584a2mr8868778eje.25.1647610912681; 
 Fri, 18 Mar 2022 06:41:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/BdGNh9JsyvjgFzL96Y9Vz6rTgp8OmTHioc8M6Nr9yVk3fxjLP8PWfjOZehG7pgTumaNf0Q==
X-Received: by 2002:a17:906:1742:b0:6d6:c4f5:84a2 with SMTP id
 d2-20020a170906174200b006d6c4f584a2mr8868744eje.25.1647610912407; 
 Fri, 18 Mar 2022 06:41:52 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id
 i3-20020a1709067a4300b006dd879b4680sm3812678ejo.112.2022.03.18.06.41.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 06:41:52 -0700 (PDT)
Date: Fri, 18 Mar 2022 14:41:49 +0100
From: Andrew Jones <drjones@redhat.com>
To: Bill Wendling <morbo@google.com>
Subject: Re: [kvm-unit-tests PATCH] libfdt: use logical "or" instead of
 bitwise "or" with boolean operands
Message-ID: <20220318134149.i2dqdaiwk3twbixn@gator>
References: <20220316060214.2200695-1-morbo@google.com>
 <20220318093601.zqhuzrp2ujgswsiw@gator>
MIME-Version: 1.0
In-Reply-To: <20220318093601.zqhuzrp2ujgswsiw@gator>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: lvivier@redhat.com, linux-s390@vger.kernel.org, thuth@redhat.com,
 frankja@linux.ibm.com, kvm@vger.kernel.org, david@redhat.com,
 kvm-ppc@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
 pbonzini@redhat.com, imbrenda@linux.ibm.com, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Mar 18, 2022 at 10:36:01AM +0100, Andrew Jones wrote:
> On Tue, Mar 15, 2022 at 11:02:14PM -0700, Bill Wendling wrote:
> > Clang warns about using a bitwise '|' with boolean operands. This seems
> > to be due to a small typo.
> > 
> >   lib/libfdt/fdt_rw.c:438:6: warning: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> >           if (can_assume(LIBFDT_ORDER) |
> > 
> > Using '||' removes this warnings.
> > 
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  lib/libfdt/fdt_rw.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/libfdt/fdt_rw.c b/lib/libfdt/fdt_rw.c
> > index 13854253ff86..3320e5559cac 100644
> > --- a/lib/libfdt/fdt_rw.c
> > +++ b/lib/libfdt/fdt_rw.c
> > @@ -435,7 +435,7 @@ int fdt_open_into(const void *fdt, void *buf, int bufsize)
> >  			return struct_size;
> >  	}
> >  
> > -	if (can_assume(LIBFDT_ORDER) |
> > +	if (can_assume(LIBFDT_ORDER) ||
> >  	    !fdt_blocks_misordered_(fdt, mem_rsv_size, struct_size)) {
> >  		/* no further work necessary */
> >  		err = fdt_move(fdt, buf, bufsize);
> > -- 
> > 2.35.1.723.g4982287a31-goog
> >
> 
> We're not getting as much interest in the submodule discussion as I hoped.
> I see one vote against on this thread and one vote for on a different
> thread[1]. For now I'll just commit a big rebase patch for libfdt. We can
> revisit it again after we decide what to do for QCBOR.
>

Now merged through misc/queue.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
