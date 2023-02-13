Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9998F5F
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 16:01:34 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id a8-20020a17090a6d8800b002336b48f653so11364828pjk.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 08:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HfKMheuMnk2N2hnnABuf2/07WBxZ/fjWOaNC2gda/eQ=;
        b=mNDXaatgSfc8naau84uWhzZcsql/fhj3yH/4/0kDcOgwGklnFmSAmam+weDVjFDPnu
         o/dNPkJRxgPzStSSXOzCPlKQHOT0rb1Ih5t3qQ/IavNTDo1OoNRMiinqeh7Ee4fn3eXb
         EoNI1vgOk2Dq2bsBgMzYsRToCf3fb5a+jV+BZv5civX3pinCfmB7QXggCoOlEnVepa37
         9oQSMyT9VLDj8RcT+FzXG9eLNmroee+DVezSCupMGXJcWs35TLeIe1KX0EYjb5OlR2k9
         6xtMpiYoCALs3pjnk5Ls4CzSACzmeO19HHhb1KXsD506/MCMr3O7Boopf2Oi6JyTL0Oe
         httg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HfKMheuMnk2N2hnnABuf2/07WBxZ/fjWOaNC2gda/eQ=;
        b=hy5gecvbh2wS1JdCtOF+Ez1UGRlWHfgg2g0a6MiFJhboBvfbrafFrHOo4dUo1gW0NF
         aY01PTkdTU7IUZ94BxlEbeoWGa78QKOAynBw5tPOu5tISnMnijMavxwL1pWbp07F+myy
         VMW60Cx6ob6lpdynSF4HDLYLRuRM3VazBslcnJ/CMPUUOmF4rLeiceBTxa8DGDQfG8rM
         3h7inns3F4wRt2sh79bwJHYE2PpeS+MllSMUGsM7UV6qIjhmmDl91Xdr105MKBoUskBK
         yvzheBunB6PH/rRlMFwf28deG48ZxCH8IyY0xK1Zn2nqwFHToF9PaCEnGZ9OE9cEW5lD
         pgiQ==
X-Gm-Message-State: AO0yUKVuZc40W8T4QjgNTi3JErBJfNQwPPpYAvVRoZKasttHV/uB0Dwr
	OAW5fKmQwJFnuddDI7PMoZi8YQ==
X-Google-Smtp-Source: AK7set91zlp5gLivK7fJ76YzrLhyC6/M7PZRmP+Ohh69tUMrhNnlq5foVfkJZNHiszA+axklomXnGQ==
X-Received: by 2002:a17:903:3113:b0:198:af50:e4de with SMTP id w19-20020a170903311300b00198af50e4demr496739plc.4.1676304094069;
        Mon, 13 Feb 2023 08:01:34 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e23-20020a62ee17000000b00594235980e4sm8162073pfi.181.2023.02.13.08.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:01:33 -0800 (PST)
Date: Mon, 13 Feb 2023 16:01:29 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [RFC PATCH v2 5/6] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Message-ID: <Y+pe2T2uK2efUNve@google.com>
References: <20230211013759.3556016-1-oliver.upton@linux.dev>
 <20230211013759.3556016-6-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230211013759.3556016-6-oliver.upton@linux.dev>

On Sat, Feb 11, 2023, Oliver Upton wrote:
> Finally, we need a flag to let userspace know what conduit instruction
> was used (i.e. SMC vs. HVC). Redefine the remaining padding in
> kvm_run::hypercall to accomplish this. Let's all take a moment
> to admire the flowers and see how 'longmode' tied up a full u32 in the
> UAPI. Weep.

I don't think it has to, at least not for other architectures.  No other arch
currently supports KVM_EXIT_HYPERCALL, so breakage is extremely unlikely.  E.g.
we can likely get away with this, and then just have x86 add new flags at bit 32.

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 55155e262646..7d3ad820d55c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -341,8 +341,14 @@ struct kvm_run {
                        __u64 nr;
                        __u64 args[6];
                        __u64 ret;
-                       __u32 longmode;
-                       __u32 pad;
+                       union {
+                               /*
+                                * Long Mode, a.k.a. 64-bit mode, takes up the
+                                * first 32 flags on x86 (historical sludge).
+                                */
+                               __u32 longmode;
+                               __u64 flags;
+                       };
                } hypercall;
                /* KVM_EXIT_TPR_ACCESS */
                struct {
 
