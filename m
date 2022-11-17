Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1B88F7F
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 22:32:57 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id 130so3144197pfu.8
        for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 14:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JJnX0WEos5jTRigFggqcWTgwGYoctrWx0Q/bRYwgPOw=;
        b=orjwgIe8kl6hEsdghGmcAPLmmi79K3QzB0hGVLCFUsglgQGZ8IidYAjJg/GV/FkMG7
         YB2CDLhUOoJ2G1Mxu+LekKxKsCieo31v5V6eqREZVDobQElRzRHpP1yyPiS1SIh6qc9E
         syPdIm+LBmeWIDtVfWYaqyh5WhEykp+DyFu/8QImqc/L8aTMhenEivOBPO2YDaW9MNrU
         sCQdT2+9Tz4TB/z8MFExA73zCjSbEpbuT9w2ifakvP/HYNZ8q980hn3+6fb8LMQb4gu2
         sNl6/ZRrJiDtK48TYUhTcIM5kSgFa69VE7BFzSDb8a0j0LQOg6/pTb507wWlNkEK8f0b
         kCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJnX0WEos5jTRigFggqcWTgwGYoctrWx0Q/bRYwgPOw=;
        b=QvyWLyCQ1VLjD4F38GDihbfpPMqgbZ82fwlMcDWzqs9jkrXG/lZet/3VExGQPhRJ1m
         zI954EdLz3VXtrGTIxVflokU2o1w8u5JD1Lnjy/K9gHE06EX25myOyxnP1kDj1Kl6zuY
         tP7Jn+Lu0TtW/JmDmBQ9xKcnNwUA4KZ/k0MMccpk3giZbmv6GS69KMszwcFIuntdG6bW
         +wZfeD3bo7HX647uxR5ad1EF7NP6Zm14UM9Gg+d1bQw0wXYSjVO248xUunfPs1qgYIJc
         ZwSnLugaZouG9ARePh/SR5fse9xrs5EbISlxIs8YSy2ZLWkipKJ5qqWIQXI7QDaRK93G
         ZHcg==
X-Gm-Message-State: ANoB5pngtKizSH14gmiu1S+FR1FKpvNcE6cXrOC0xjwuuaU30QESlyCY
	c6q0sYN829Q0xh3eiX6HHR0odg==
X-Google-Smtp-Source: AA0mqf62hgVFP75vxpYXME1e9myoKhlSOl3NkjrteC+H66jW50x5Upfk3tLqM3B4NZYvwuXH4gz+ag==
X-Received: by 2002:a63:ff62:0:b0:476:898c:ded8 with SMTP id s34-20020a63ff62000000b00476898cded8mr4068515pgk.251.1668724376940;
        Thu, 17 Nov 2022 14:32:56 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k186-20020a6324c3000000b0046fd180640asm1561643pgk.24.2022.11.17.14.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 14:32:56 -0800 (PST)
Date: Thu, 17 Nov 2022 22:32:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Disable single-step without
 relying on ucall()
Message-ID: <Y3a2lfLLys4BtET3@google.com>
References: <20221117002350.2178351-1-seanjc@google.com>
 <20221117002350.2178351-3-seanjc@google.com>
 <Y3WF8YlvFm8NGYHd@google.com>
 <Y3WMeovid9z1qOjD@google.com>
 <Y3ZQ+fCobB4DOc+S@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3ZQ+fCobB4DOc+S@google.com>
Message-ID: <20221117223253.308hwYUdOJa4Lw3Eh-mlzYSt3kwXmScSwJV6RkP3r_Y@z>

On Thu, Nov 17, 2022, Sean Christopherson wrote:
> On Thu, Nov 17, 2022, Sean Christopherson wrote:
> > On Thu, Nov 17, 2022, Oliver Upton wrote:
> > > On Thu, Nov 17, 2022 at 12:23:50AM +0000, Sean Christopherson wrote:
> > > > Automatically disable single-step when the guest reaches the end of the
> > > > verified section instead of using an explicit ucall() to ask userspace to
> > > > disable single-step.  An upcoming change to implement a pool-based scheme
> > > > for ucall() will add an atomic operation (bit test and set) in the guest
> > > > ucall code, and if the compiler generate "old school" atomics, e.g.
> > > 
> > > Off topic, but I didn't ask when we were discussing this issue. What is
> > > the atomic used for in the pool-based ucall implementation?
> > 
> > To avoid having to plumb an "id" into the guest, vCPUs grab a ucall entry from
> > the pool on a first-come first-serve basis, and then release the entry when the
> > ucall is complete.  The current implementation is a bitmap, e.g. every possible
> > entry has a bit in the map, and vCPUs do an atomic bit-test-and-set to claim an
> > entry.
> > 
> > Ugh.  And there's a bug.  Of course I notice it after sending the pull request.
> > Depsite being defined in atomic.h, and despite clear_bit() being atomic in the
> > kernel, tools' clear_bit() isn't actually atomic.  Grr.
> > 
> > Doesn't cause problems because there are so few multi-vCPU selftests, but that
> > needs to be fixed.  Best thing would be to fix clear_bit() itself.
> 
> Ha!  And I bet when clear_bit() is fixed, this test will start failing again
> because the ucall() to activate single-step needs to release the entry _after_
> exiting to the host, i.e. single-step will be enabled across the atomic region
> again.

LOL, yep.  Test gets stuck in __aarch64_ldclr8_sync().
