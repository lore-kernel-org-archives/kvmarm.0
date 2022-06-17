Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B13DFC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 17:05:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41E1C4B2A1;
	Fri, 17 Jun 2022 13:05:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wsD6BoJ8P+8H; Fri, 17 Jun 2022 13:05:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49A8F4B371;
	Fri, 17 Jun 2022 13:05:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6C9F4B2A1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 13:05:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LRv0ZFzN9eFu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 13:05:46 -0400 (EDT)
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com
 [209.85.166.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 90A164B1D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 13:05:46 -0400 (EDT)
Received: by mail-il1-f177.google.com with SMTP id m16so1864269ilf.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 10:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=4H2OpO4Kq2nG0nxCJ9datcKzR+qnlWf0xbhrv9fe1rg=;
 b=TAW7FS7zVXqHvHquvWRUQSMyzmPJ7tVyu2hHHYvaoGtbMpC3bvIPJXHUxS9qNhnINm
 wSXH9O+r0cwO6KhCpDEx338Kah83pU5a3zDo9kRz9MGy4ghVVUq07fZhEOaB+H7/tBHE
 pxfoQYK9cyLp6rM03k/p676mk+vzD2+ivKwtSld2NPfIB6UgCvYUtGuDYBsbMkS6+gTo
 D3qN/kHn4K+B3p5f5lVhB+VC3WhGti/2TGpGL07sdlUYqoZhZKx5dnzs4GMQZwV8aWv/
 meOmImm6DM4nFffycP2bPx/OQn62KZQZu5a44W3Jcg2odtaG57Nqkn2XuXXAmXbf04uE
 +SNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4H2OpO4Kq2nG0nxCJ9datcKzR+qnlWf0xbhrv9fe1rg=;
 b=gebr2qRSeitUu2dHWimBDwlfefPrC6/CZe3TpA1WUJ/CJ0gdhQi8vGhRVaiap34O0K
 rWJ4Ejr4Eql6U+Pt+m8a7HaQyIZr/4t2CEbEub1VZjdUjeX7rC8i8qnP15bxu59H8Rmo
 xs8bPIKDs2117PQWpmcadY1cb2FgKNFkzI0Ib3Gy38/5id938yYMpZpBp9LbwSpM5e6y
 eZrp2nmdDcAdgYttrhfTVcfzXQ71NTS9l/VPvm+R7RkjuIl/Gu8XEv+Bf8KKO+RWU2LX
 4gGh5tRlVDc0B/AgBgSiWuj0MIiDTkNh5YVRcPzLk11y17dsSxXI+8Tatb9aVFaZspRt
 dzvA==
X-Gm-Message-State: AJIora/7XEjoOiZIYwayF62DQ6v+lgJ/1o8Kmz//D12dCsrXBpd2ecYM
 zY5was6DNcNQeXlczt2idGbWYQ==
X-Google-Smtp-Source: AGRyM1v7haoW1qtEvfc6oB7VBdPNkjITEbnsE7OeCDQzUUJ+pWxoufWWLAR+Wwwpo1c+rmP0BujHbQ==
X-Received: by 2002:a92:d309:0:b0:2d8:e639:4e02 with SMTP id
 x9-20020a92d309000000b002d8e6394e02mr1742450ila.313.1655485545817; 
 Fri, 17 Jun 2022 10:05:45 -0700 (PDT)
Received: from google.com (110.41.72.34.bc.googleusercontent.com.
 [34.72.41.110]) by smtp.gmail.com with ESMTPSA id
 p4-20020a927404000000b002d1d8de99e7sm511812ilc.40.2022.06.17.10.05.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 10:05:45 -0700 (PDT)
Date: Fri, 17 Jun 2022 17:05:42 +0000
From: Colton Lewis <coltonlewis@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <Yqy0ZhmF8NF4Jzpe@google.com>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
 <20220616121006.ch6x7du6ycevjo5m@gator>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220616121006.ch6x7du6ycevjo5m@gator>
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 16, 2022 at 02:10:06PM +0200, Andrew Jones wrote:
> We probably want to ensure all architectures are good with this. afaict,
> riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
> for example.

All architectures use UCALL_MAX_ARGS for that. Are you saying there
might be limitations beyond the value of the macro? If so, who should
verify whether this is ok?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
