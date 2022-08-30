Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EF1ECAAD1
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 04:27:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBDDA4B916;
	Tue, 30 Aug 2022 00:27:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z8C3GGkyoinZ; Tue, 30 Aug 2022 00:27:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3BDD4B907;
	Tue, 30 Aug 2022 00:27:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6696C4B8FD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 00:27:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nx3kjzV+NImY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 00:27:10 -0400 (EDT)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 168374B8D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 00:27:10 -0400 (EDT)
Received: by mail-pj1-f50.google.com with SMTP id
 n65-20020a17090a5ac700b001fbb4fad865so10651326pji.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2022 21:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=tveQCNdrcl8zzZ90FYJSAQp/xoPHwNHO3f5B145IGDY=;
 b=jz5ryMUneNPtN7GgAbdob+y42sDrVxRuBlqA3QA9oeD1pieZtFXjP021CLo/r+B8bv
 MYbJ7ecSXA82j8N0LGSRSWGBEUhc3gl753fZP/eq9G6cgLilZiGUBe9U0WkOOEPuzjZF
 1K3HPtO4P5guX5tEHivGDwt+5tsoSrBpSv2YMAohOLencXK9GT5KAEjxZPzgLhtXs8hu
 gQg912iU7/NlDTQXrg/CEmP/aR5c+40JbNsB0FzAY+4nR+pg565IYviyzm5c/PrLrHLt
 42P316IO38WW173exoDa9F/uBYTC0uVc+zDhMVmIYiRyS2CFUFzmi4Iwz9ul83sq02Yi
 qJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=tveQCNdrcl8zzZ90FYJSAQp/xoPHwNHO3f5B145IGDY=;
 b=luylcrp9i8dh03DqVG/TQHCPyYUR3dUh284uNZ705/uZuuxyaSonYU6ejIaoXS05NG
 eiejwjRFFjQUd1frEdBrFSYtWolp9yWenEobLTyTsDgmZSZzg+70CvRq2mY/3U4gNTGK
 yHa9TrrwUM2AqS8Jq+x5FjxbfDTVGwihwgf24Tj+fzkf7h9wjWOkCZ7fU4b1VidBbzTY
 jT1V031gBtn7kxT4Wb1aUvBIbTJldItzKIHN51p3LlmoobGI3OPmg0PYP7rpEUxQZZjH
 hHgjOBNxHlCZR6PIlC3tpPt2Mh9IrR1EH9tif/RXfK7by4427VIGxEqfIlgLJG7z3rw3
 k/Tw==
X-Gm-Message-State: ACgBeo0U4nXGTXHUynkqEK0BNudH1ZAZ975qKrc6mUI1nO5KkYAiTxBP
 W8hgyFUVqvsU1uF4AZiS3ExUKA==
X-Google-Smtp-Source: AA6agR6j3CrMGk4TPMCPwBvaE51o8QHOWIUKsxAkxuonGlXOsZKabqIh/v6aYfhgn/tTEr+AwX2Jlw==
X-Received: by 2002:a17:902:efca:b0:174:c901:aa8d with SMTP id
 ja10-20020a170902efca00b00174c901aa8dmr7736459plb.164.1661833628777; 
 Mon, 29 Aug 2022 21:27:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 nm21-20020a17090b19d500b001eee8998f2esm7541792pjb.17.2022.08.29.21.27.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 29 Aug 2022 21:27:08 -0700 (PDT)
Date: Tue, 30 Aug 2022 04:27:04 +0000
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [PATCH v5 7/7] KVM: selftests: Add ucall pool based implementation
Message-ID: <Yw2RmCujuaOczFTY@google.com>
References: <20220825232522.3997340-1-seanjc@google.com>
 <20220825232522.3997340-8-seanjc@google.com>
 <20220829163627.qbafyl4qz5cxxue5@kamzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220829163627.qbafyl4qz5cxxue5@kamzik>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Tom Rix <trix@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 llvm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Peter Gonda <pgonda@google.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>,
 Atish Patra <atishp@atishpatra.org>, linux-arm-kernel@lists.infradead.org,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

On Mon, Aug 29, 2022, Andrew Jones wrote:
> On Thu, Aug 25, 2022 at 11:25:22PM +0000, Sean Christopherson wrote:
> > +static struct ucall *ucall_alloc(void)
> > +{
> > +	struct ucall *uc;
> > +	int i;
> > +
> > +	GUEST_ASSERT(ucall_pool && ucall_pool->in_use);
> 
> ucall_pool->in_use will never be null.
> 
> > +
> > +	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> > +		if (!atomic_test_and_set_bit(i, ucall_pool->in_use)) {
> > +			uc = &ucall_pool->ucalls[i];
> > +			memset(uc->args, 0, sizeof(uc->args));
> > +			return uc;
> > +		}
> > +	}
> 
> nit: blank line

Got 'em.  Thanks for the reviews, much appreciated!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
