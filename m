Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230BC1FAE
	for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 09:57:09 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id i21so7097260edj.10
        for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 02:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mvHL5Drr+3t1aS/5ADf3q7iM5WIuHk2AYt4Ze0ZBgjk=;
        b=XzOlmJP/jS7VT1xg6wG+42FDDXw981TfzCCruFtGWZepNQEEDI1xBoIQxendEL6nVw
         gV++vJ7t7L7EWZHnXPGmx0WFIw3SkrgmFHy7yiCJmdCaMetbBp4gmGb8H0OpwnEhz4uA
         NXR0EIjkLtokHm+btvWViZasIH8uRkLuXGJU84pBFCN9ZAMKWmzhw1vgpkv0EaZCYXGC
         lRB/IpHGfMApklvbsCU3KW8TkXSHNoNTekYSvt6CgCgcciE56e87YjFKyn9JXOirreG8
         e5BSpaR4vnFx+66Pxz1mIral+3sROyLK+wRy96aO3CnMOlMYCH/XbevP2WLneL9Q/7Yd
         BWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mvHL5Drr+3t1aS/5ADf3q7iM5WIuHk2AYt4Ze0ZBgjk=;
        b=kxCTOrH7dUAgd2OE3WaUepCwBEMbaAeZeRicy8C15ZCt8bza0kxq1XvaKIYdp9+CfT
         XDoYMyzNMv3/97YBGqvhqOoS4qvsLO6jaT7jfgWsPlzb9HI96B7ClBi3Lrg5hrHrsgTs
         QXypiasOnxZMR0MNWBKzDpzgv0nNfOxWxpOIfApmh08xfvGO/9okgoAlbKRdZuVPE383
         cWAp2qkGpUrR7xJOH7YXrIxqmwF5vvQ2kqefO7kJn3ik8l1I3vAsYSdAhonysRLaGb8+
         1JGklgbCYOpabCLq8CKJW4tjx32mKJhV4hWcsYkptYq04lQOB2H4FbJsTp7d1WO2Yg4T
         q/KQ==
X-Gm-Message-State: ACrzQf1tyy11MvknV+5tw+XI29uQpV9cSYTm6eVi46N22kLL2UjmWRgY
	til9b9Ad9XG3RZY5e0NYlcPA/A==
X-Google-Smtp-Source: AMsMyM5zJVsp3vp9yM+1qZ9xU/7wt91EQOkPXZmY19wmU4+a4o6tvJjAEaJRmC8JNHIxmOjkkdPfsw==
X-Received: by 2002:a50:ff09:0:b0:456:fd61:83b3 with SMTP id a9-20020a50ff09000000b00456fd6183b3mr48978165edu.166.1666951028189;
        Fri, 28 Oct 2022 02:57:08 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id x1-20020a05640226c100b00443d657d8a4sm2435255edd.61.2022.10.28.02.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 02:57:07 -0700 (PDT)
Date: Fri, 28 Oct 2022 09:57:04 +0000
From: Quentin Perret <qperret@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Redefine pKVM memory transitions in
 terms of source/target
Message-ID: <Y1uncNq2oyc5wALG@google.com>
References: <20221028083448.1998389-1-oliver.upton@linux.dev>
 <20221028083448.1998389-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028083448.1998389-3-oliver.upton@linux.dev>
Message-ID: <20221028095704.kmFYUgdLEDJzgEqyIvrXEr5ICsCuSpRnRlsKsIjCRDE@z>

Hey Oliver,

On Friday 28 Oct 2022 at 08:34:48 (+0000), Oliver Upton wrote:
> Perhaps it is just me, but the 'initiator' and 'completer' terms are
> slightly confusing descriptors for the addresses involved in a memory
> transition. Apply a rename to instead describe memory transitions in
> terms of a source and target address.

Just to provide some rationale for the initiator/completer terminology,
the very first implementation we did of this used 'sender/recipient (or
something along those lines I think), and we ended up confusing
ourselves massively. The main issue is that memory doesn't necessarily
'flow' in the same direction as the transition. It's all fine for a
donation or a share, but reclaim and unshare become funny. 'The
recipient of an unshare' can be easily misunderstood, I think.

So yeah, we ended up with initiator/completer, which may not be the
prettiest terminology, but it was useful to disambiguate things at
least.

Thanks for the review!
Quentin
