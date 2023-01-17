Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279FA4C9A
	for <kvmarm@lists.linux.dev>; Tue, 17 Jan 2023 15:42:09 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so11075987pjg.4
        for <kvmarm@lists.linux.dev>; Tue, 17 Jan 2023 07:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=raIP5zSqF/STW+kTCBVQJ+PuTh0fIF3QkrpzqbxnVwM=;
        b=Fboqqh9dagbWo2L8wq1Lo26iSaSU57WhxjC/fOz7ecCUNGGEDVLeXoK5K/pHZwcsFV
         N9jlLxyCR6qNXQQ4U7mpMErHB3ZrEWyqQtK2JQndhA0MmCFiGJ+4PPhTRD0Wix0EL65j
         MsYHUDHxtRNkvOQ0WUDga80seOuHKWPkpKj+FGWEAdrMpGI0dVnRWM5khsCPm4X7lwaH
         x+1LaU365neNHCMM/NnCQEGLIUB0p9uhI/3oVwVMGYmas44XJFXRd2YVZkXp0yoqHUtJ
         ciWpysAmyUCCthwpSIl7KFTDHsYIFtORoQMrRwss/5rncAUrPaGaZx9iAg7bu43XjA0x
         fYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=raIP5zSqF/STW+kTCBVQJ+PuTh0fIF3QkrpzqbxnVwM=;
        b=ltckeYXCamFobI+lF/xU7/7jHTzKprACTs08++q5tv7IHCkCorYcSF2O2WKXeM2jeQ
         Dvdy+LzEX0mQyotK9Ye21mmxqX5RCobPhidIAz9rmx36Mp3Sw4FPHtiO9PHPmPhbNmmE
         IYhhqEiNzYacJZkwSwBgs+Ymutoyfms1bm2MrL4e248tAH77qeUp3p7rlSjByAqrDvOL
         wZpaOG0MhefbTGDfvTpnV8JmTfLPu4m5/phXihNsjJWITIjuuQTUQZJnfc/WMNyMNM1V
         uo8YKekvVagzkQ9B2fNIZXbfAjeJf0T0/a+qUsFXmdWl7Fnl8akxNLpdQ2hXP+JmcXjv
         jXaA==
X-Gm-Message-State: AFqh2krk5/3txA8Q0YWUhx2Ww7kAZBpSnbGoHczpGzekBu7BMBAxNuz+
	puVY1aWtYj6SD4zrBV8+JLlZew==
X-Google-Smtp-Source: AMrXdXtc4FtedAeo9e0ZaQ0CoHayTm55NeSTXxytLBxVQsTrdtckjUUE0ev7gjaj6X6vcVC1fBOKfQ==
X-Received: by 2002:a05:6a20:a883:b0:a4:efde:2ed8 with SMTP id ca3-20020a056a20a88300b000a4efde2ed8mr2357042pzb.0.1673970128358;
        Tue, 17 Jan 2023 07:42:08 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p10-20020a17090a348a00b00218d894fac3sm20692438pjb.3.2023.01.17.07.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 07:42:07 -0800 (PST)
Date: Tue, 17 Jan 2023 15:42:04 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	pbonzini@redhat.com, maz@kernel.org, corbet@lwn.net,
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	ricarkol@google.com, eric.auger@redhat.com, yuzhe@nfschina.com,
	renzhengeek@gmail.com, ardb@kernel.org, peterx@redhat.com,
	shan.gavin@gmail.com
Subject: Re: [PATCH 4/4] KVM: Improve warning report in
 mark_page_dirty_in_slot()
Message-ID: <Y8bBzKF17IdZP9eF@google.com>
References: <20230116040405.260935-1-gshan@redhat.com>
 <20230116040405.260935-5-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116040405.260935-5-gshan@redhat.com>

On Mon, Jan 16, 2023, Gavin Shan wrote:
> There are two warning reports about the dirty ring in the function.
> We have the wrong assumption that the dirty ring is always enabled when
> CONFIG_HAVE_KVM_DIRTY_RING is selected.

No, it's not a wrong assumption, becuase it's not an assumption.  The intent is
to warn irrespective of dirty ring/log enabling.  The orignal code actually warned
irrespective of dirty ring support[1], again intentionally.  The
CONFIG_HAVE_KVM_DIRTY_RING check was added because s390 can mark pages dirty from
an worker thread[2] and s390 has no plans to support the dirty ring.

The reason for warning even if dirty ring isn't enabled is so that bots can catch
potential KVM bugs without having to set up a dirty ring or enable dirty logging.

[1] 2efd61a608b0 ("KVM: Warn if mark_page_dirty() is called without an active vCPU")
[2] e09fccb5435d ("KVM: avoid warning on s390 in mark_page_dirty")
