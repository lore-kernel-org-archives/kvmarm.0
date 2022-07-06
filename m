Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF0FCCA47F
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 15:29:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBB894C06B;
	Wed,  6 Jul 2022 11:29:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cV9ldEXJ19Aj; Wed,  6 Jul 2022 11:29:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE90B4C07D;
	Wed,  6 Jul 2022 11:29:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DE264C06B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 11:29:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bVdKyKdQiEQ6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 11:29:35 -0400 (EDT)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com
 [209.85.166.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 737EB4C04B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 11:29:35 -0400 (EDT)
Received: by mail-io1-f44.google.com with SMTP id d3so14284535ioi.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Jul 2022 08:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=/g+2QDhf/M+KKE2UkJnZoUTJqeRg0COeESHnYwx3rvI=;
 b=QTml3dMluEIkRRHy+OtIGUwJTwOOk4eTs/ho9Y/BSbNv7IHRat+Cma+KaEzTFO/ric
 6i14jc7Cj/q+zKTH4m/NuQCTOyhO/nIAULH/hZSqPUiPTY886coDBzr5mhwLNXi4+8EB
 grb1qn/16vQshvPb4U+xbuPKwQuQRgdP/+ZKTAz49gR/hMelyP+Kdsv9x7CHhFWetU+E
 0dLzqM9S7Ldlcm71Hk3mvy4ayAnVq9m4ziBCVMacdytQ43V0ay8knAgE6gkDB2siPU9v
 eln5bjqT2B3qM3c7TinZJImvxbqC9RqWnYjsgRXiSLMZxf0feugmTwSG7QnQUZDrASmm
 WX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/g+2QDhf/M+KKE2UkJnZoUTJqeRg0COeESHnYwx3rvI=;
 b=2IyX9J8RN+4F2LaYVxYjqLAMnQJvl1iNw1Lg42Q1LtMH6459bvSgxRS//ATEh3kzr+
 mBnj7d42XITtMtcSQxtjj/KdxmKu6TMAd5zHnxh0KfBDsvdUMLyFvEDGzbR2T+sNsBMQ
 QXLHXu/PKVOu44jTZLav1qiumsfN4Y0VoTRfpDcm0RzXdRDYBkteI16GXNzksTum5Xrk
 q5oe/psfNzoKGkC9uK9S57tZrewfj1l1FAd6xL/EkWAtm+lgSIQNWASJT0UDmF040EtY
 q8DTRLOChehUr5BbKkBqI7A1uNjjVsdzed6GV8UaaRO7YBr4jl09Hr78OwDvhwYzMj1U
 q4CA==
X-Gm-Message-State: AJIora+gTYTG1aINpA4F6Y8fqn2ZqWKxj7LbPA++HB48/AWXjlrjrDY/
 yfho7CgalexUuPVxnC3C9KX0jw==
X-Google-Smtp-Source: AGRyM1v3zPhIeXW9MdHQumXXkgoBSrJYc1+K8Lq6AAlHI2A+/POU8SMD2YQI+pgfkywwa0XVa2xS4w==
X-Received: by 2002:a05:6638:409f:b0:33c:d757:2e4e with SMTP id
 m31-20020a056638409f00b0033cd7572e4emr23791804jam.221.1657121374715; 
 Wed, 06 Jul 2022 08:29:34 -0700 (PDT)
Received: from google.com (30.64.135.34.bc.googleusercontent.com.
 [34.135.64.30]) by smtp.gmail.com with ESMTPSA id
 y25-20020a056638229900b00339d244c4a6sm1718724jas.23.2022.07.06.08.29.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Jul 2022 08:29:34 -0700 (PDT)
Date: Wed, 6 Jul 2022 15:29:30 +0000
From: Colton Lewis <coltonlewis@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4/4] KVM: selftests: Fix filename reporting in guest
 asserts
Message-ID: <YsWqWkl8ymLFqxgY@google.com>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-5-coltonlewis@google.com>
 <20220616124519.erxasor4b5t7zaks@gator>
 <2fc82066-f092-bc19-ae69-6852820f41ef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2fc82066-f092-bc19-ae69-6852820f41ef@redhat.com>
Cc: thuth@redhat.com, kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
 g@gator, maz@kernel.org, vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Jun 20, 2022 at 02:04:43PM +0200, Paolo Bonzini wrote:
> On 6/16/22 14:45, Andrew Jones wrote:
> > > +#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {	\
> > > +		if (!(_condition))					\
> > > +			ucall(UCALL_ABORT, GUEST_ASSERT_BUILTIN_NARGS + _nargs,	\
> > > +			      "Failed guest assert: " _condstr,		\
> > > +			      __FILE__,					\
> > > +			      __LINE__,					\
> > > +			      ##_args);					\
> > We don't need another level of indentation nor the ## operator on _args.
> > 
> 
> The ## is needed to drop the comma if there are no _args.

I haven't heard anything more about part 4 of this patch in a while,
so I'm checking in that I didn't miss something requiring action on my
part.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
