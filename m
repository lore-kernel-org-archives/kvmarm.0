Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EBC6ADF
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 16:23:24 +0000 (UTC)
Received: by mail-ej1-f42.google.com with SMTP id qk9so5283892ejc.3
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 08:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ffOMrqHbGPKnX9DON08suhw00B/x5l9qlgIhBCvn1s=;
        b=GcVbR78qgq1zGKeFap4dpyJP2ETn3kww5rg3v8dPl3tCWN0G6qxnGcbwgcX5MCo3OM
         fKWfEFTBvO7N8XCZBPsxpIZJu/I7SUe3aPGwiRpN/CQgiksUDLrb6z4cKnWd08AfEpdZ
         r94BbeUn5ovd//wzHhKXPJAWTKlrbHK2MlOIz3fbM4mGNb97gj9dHvVIeeiBbVWMUG83
         kIoNpiUMsufVsm/m95AH/BSknL/IIYi4+Au5NXHpzpAF6U9MwGhYl2DJgI8UrQgHnbO0
         7dRNIeeoHyKJg18727lHNV+cCrVrJsiUn1rn7oMXL7Wu9l4f3Ev75gNhks+qShMbBZI8
         WEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ffOMrqHbGPKnX9DON08suhw00B/x5l9qlgIhBCvn1s=;
        b=Rvw0NxZsvfeoKtsgIT9f7oSbu4naoX867Cu9Bd3xwtBKhK8E7FAg2PFrEJqmxccmQG
         d3jdqqzR7ruesCs06MmmbS3BJSOl6GJeUIX5Ucr3lwwsolP6pZdr3PGpsFPuh2sGBD1b
         m6Wh7zhiWTzUl2LKPSYzOuqeRCmruLKAtjjc5ZDcBxUzs97VA1uuEBa8K620VTrGsbiZ
         fwBE0U+T30I3ijo8c6tmgb3GQMHU+qs3HOB1IbAjti/ZJHuK7n4TmHK5PwwW6mkcaRxB
         VsMGVGrGZsnzqwh0cJ1ZDMlO/W9oIvB+a091YGKDfmLf9Wq4tAe+vEGqdMl80v6gix0E
         iIAQ==
X-Gm-Message-State: ANoB5plJHp2k83LAFi2Q9PEMk1tdh6JeooDzqjc5HrHWjfYRJjVwVj5X
	qYQU9idSi0psPSjWoD2MSARTHg==
X-Google-Smtp-Source: AA0mqf7cWc12/11dRI8UuaKffduEO9pgwBnCtENeaj4X4vsk2ZRqNQGH/MayWHmkzyTTju2hui+ZmA==
X-Received: by 2002:a17:907:a426:b0:78d:f456:1ec6 with SMTP id sg38-20020a170907a42600b0078df4561ec6mr3278655ejc.23.1670516602675;
        Thu, 08 Dec 2022 08:23:22 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-748-2a9a-a2a6-1362.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:748:2a9a:a2a6:1362])
        by smtp.gmail.com with ESMTPSA id i9-20020a170906698900b007bff9fb211fsm9884789ejr.57.2022.12.08.08.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:23:22 -0800 (PST)
Date: Thu, 8 Dec 2022 17:23:21 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] KVM: arm64: selftests: Align VA space allocator with
 TTBR0
Message-ID: <20221208162321.d745p2lsedxdf7v6@kamzik>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-4-oliver.upton@linux.dev>
 <Y5EtP5z6rxSK1VUe@google.com>
 <Y5EvVtAoDSHvIKie@google.com>
 <Y5E5UixcJQ4+tNYg@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5E5UixcJQ4+tNYg@google.com>
Message-ID: <20221208162321.pt5E5r2iwtEi4SsYVDPU08lY9Ui_4gneUtqIf8v0ulA@z>

On Thu, Dec 08, 2022 at 01:09:38AM +0000, Sean Christopherson wrote:
...
> Actually, before we do anything, we should get confirmation from the s390 and
> RISC-V folks on whether they have a canonical hole like x86, i.e. maybe x86 is
> the oddball.

riscv splits like x86.

Thanks,
drew
