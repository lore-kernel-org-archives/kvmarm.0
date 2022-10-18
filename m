Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0855B4C7C
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 15:13:41 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id d26so32976780ejc.8
        for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 08:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ngFDrkYh7TfNwn3cKsyTj9NZFSvpWOTJCwLE4FnKgSU=;
        b=LG7auiBDm+jf1sMd/H8YfO2YVkDDZ5DW9ctKwMPFzY1OHJFJ97XDUMa1K91CZuf4rw
         vmoW94wTquKSft8eCf8EkWz//J6bu/jxy4oeGSmrivniDMGHmFYtjp+fZ7hH6rQ4iJJ9
         8nSEYgj5nKzs0/i9wcUXMr/jh/wfECYCX+6yrl57Vgj8JW9BtqDiwRClm47UKsk2peA6
         ztYDn8DznNImiSqMai2cJQC9A8dt0bccHBxXUYVB909dIv86bIx3/C5Y3w7SsOdlXTLw
         PGwd3JyJy81q8UJfQwJv62s0xT8dqiIu3D5Vm2s/SEVIrabDdxdE/feH9UDR05jKKK3+
         uRNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ngFDrkYh7TfNwn3cKsyTj9NZFSvpWOTJCwLE4FnKgSU=;
        b=kKeq95FhDbr3J0xEDCQhn1Deq1CkqYPI64MZCzghApV1JPlTYK348Vvscf7+0F8RuK
         MrDpjhp0I9z/XOkvdiGoX8lMkkiqYmkCWVeH+LqX/tzlB6jGIKgiqkQxfD8drhVLI+eo
         ad+6Trc9ha7bDkyNGg+Z37OAXiYS/a2n9pm0O4YbU4hryi9vqqN0rT/aaMkpzRTxuNfD
         ySzrOv80i/X8AAV3ABKu19zB4bL0lBy9M0qevwATog1mR0RKaEgNhsCh0XtiRrp5DUOz
         CAzPTL+aoni0vk/82mTIcbyKpocMlGoVtndJbN3wJofHHSd9oe8coUnI/pknWc/gbuWn
         5+XA==
X-Gm-Message-State: ACrzQf0eRaywMrwGJeZs8gxYVEvDzMw2JtxU3DKgKFOgIjCY0uExYeTS
	uYvPwamMAd19SscubGTSt/3htA==
X-Google-Smtp-Source: AMsMyM5VsSscnj0Yt6uKT9OUKBIQcGNB+oVkvUrofbuFrg2x581bniD3XJvupkVdIqE5x+cIa2clIQ==
X-Received: by 2002:a17:907:94c7:b0:78e:1c4f:51f9 with SMTP id dn7-20020a17090794c700b0078e1c4f51f9mr2961662ejc.200.1666106020078;
        Tue, 18 Oct 2022 08:13:40 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id bo15-20020a0564020b2f00b00456d40f6b73sm9019291edb.87.2022.10.18.08.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 08:13:39 -0700 (PDT)
Date: Tue, 18 Oct 2022 15:13:36 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <Y07CoADQH4v7cY5Y@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-13-will@kernel.org>

On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> +/* Maximum number of protected VMs that can be created. */
> +#define KVM_MAX_PVMS 255

Nit: I think that limit will apply to non-protected VMs too, at least
initially, so it'd be worth rewording the comment.

Cheers,
Quentin
