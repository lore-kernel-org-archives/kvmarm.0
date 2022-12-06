Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8F727727
	for <kvmarm@lists.linux.dev>; Tue,  6 Dec 2022 18:10:36 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d3so14715851plr.10
        for <kvmarm@lists.linux.dev>; Tue, 06 Dec 2022 10:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gAdL/5nVVJu1FQlGTdfBjUls0ERNiH40RtP9DKw3LIs=;
        b=l9AGT4fXhM1oH7Du6wFnaTWjSCn3ASy0EdsFYwoxpz1XTmSJrI/6IYPrztRWGtgphI
         MEU1JwB6naZw7c/1ettMldjjpLk7glwpCWqV3EXpRuhUI+cM9iyuVCU+X8uFtQpMw16H
         y+VgP6Yz+mAMFxaAy3HgfBPOTFYdo5y/iogmk26sWTFOPpJyLaBDhg94MEROnHf5IE94
         nWYww6CfABnUnL1AnWY2Cgwf8IRzYPXH3CPErKTJKwYOxZqve3srRPJGRu+YDWCJOMyj
         ciVWMbA+0QFhqsdHTxv5x8llaaAKjhSyqtXi87fJCtsbFm+lXv45WSeSP6LhgyyqgED4
         rVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAdL/5nVVJu1FQlGTdfBjUls0ERNiH40RtP9DKw3LIs=;
        b=SP108fd6BSLH87safqSD8oR8dI48jAg31QpOchvICi4GuOR5hGusndDkVHMko6pQmS
         yXqrW52fcbzFx+2XdB24AcGyAZ2GhAmCnjqXsIenON1zDVYUyOEJZpPzBUANCwz8B+Gd
         vDMOdAeaCux/ttv17GHzw0LxN03oNImxikmxDXyRKMU53ZgCT7nnYfmq3oZGp70QLayE
         99dX2ICnLO53dzU+sX3NKoubjeczD6cUcxMxssUgCk9AUMx//D7p9O5S3lojjSTF0+GS
         pzxC0ZwoJpbWy6nU1IBBB9ERwXE6OQodpSuCiEj1ArFS+o1dITdWEtSq8Tiyetc4NMqC
         KVBg==
X-Gm-Message-State: ANoB5pn5RKsWPoxvQAr1IsDg3lqADDzDPUKddmIdDWOUIKhliC/cNly9
	wjrvKWsXTKUOPfEuJg47CTRI+w==
X-Google-Smtp-Source: AA0mqf5SWGEOLKnaGxze9XgAsm4nFZyJ++7ROo35teN3Ikc66p+MXKu2i9uybgiJng0VsXfgkbFF9Q==
X-Received: by 2002:a17:90a:c68d:b0:219:d415:d787 with SMTP id n13-20020a17090ac68d00b00219d415d787mr11690151pjt.127.1670350236316;
        Tue, 06 Dec 2022 10:10:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902ec8e00b001897916be2bsm12957433plg.268.2022.12.06.10.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 10:10:35 -0800 (PST)
Date: Tue, 6 Dec 2022 18:10:32 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Andrew Jones <andrew.jones@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Ben Gardon <bgardon@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>, Fuad Tabba <tabba@google.com>,
	Gavin Shan <gshan@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	James Morse <james.morse@arm.com>,
	"Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Peter Collingbourne <pcc@google.com>, Peter Xu <peterx@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Quentin Perret <qperret@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Steven Price <steven.price@arm.com>,
	Usama Arif <usama.arif@bytedance.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Will Deacon <will@kernel.org>,
	Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
Message-ID: <Y4+FmDM7E5WYP3zV@google.com>
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
Message-ID: <20221206181032.DO_opxSli0yxYfW7DWSTKcE_cNjFMoliPuQzmxohQxA@z>

On Tue, Dec 06, 2022, Paolo Bonzini wrote:
> On 12/5/22 16:58, Marc Zyngier wrote:
> > - There is a lot of selftest conflicts with your own branch, see:
> > 
> >    https://lore.kernel.org/r/20221201112432.4cb9ae42@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201113626.438f13c5@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201115741.7de32422@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201120939.3c19f004@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201131623.18ebc8d8@canb.auug.org.au
> > 
> >    for a rather exhaustive collection.
> 
> Yeah, I saw them in Stephen's messages but missed your reply.
> 
> In retrospect, at least Gavin's series for memslot_perf_test should have
> been applied by both of us with a topic branch, but there's so many
> conflicts all over the place that it's hard to single out one series.
> It just happens.

Alternatively, we could have a dedicated selftests/kvm tree (or branch)?

I almost suggested doing that on multiple occasions this cycle, but ultimately
decided not to because it would effectively mean splitting series that touch KVM
and selftests into different trees, which would create a different kind of
dependency hell.  Or maybe a hybrid approach where series that only (or mostly?)
touch selftests go into a dedicated tree?

I get the feeling that I'm overthinking things though, this level of activity and
conflicts should be relatively rare.
