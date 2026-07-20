Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268F4449B37
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 19:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576727; cv=none; b=Usvx9KSP0gWeE17TT+ZB2sF3B99PJlPlwh41e7vlpSxsfOm32FBK2eyFW199WarVHTsaW7Hy/RcjbX7RDpwr1u8Xs5ZgGg7Ftw/yk6fGO06WH3EScq6YB1mDTcaGlzy4FfkDacEQVwWfD9Ggxw30HiYgNbY88DwObetwQAhsb38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576727; c=relaxed/simple;
	bh=frozKVuQVd8ZbwX/C61FHdCqlcwZaoKXyAlnvZZKPD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I1aOv3U6jJn9e2r1GIm+BOxU/Xw/bN0SqIiyg5BSyu8uIn0wXviJ7HZjgiUzSebnf/b/HQMVHCMJDJTuak2rbQkvFIxPFVhkSJE7jCi6mt4ixcbsN4ayx0Gekwxd4Ek8KGQiiM3dWxDTexuDw/OfvN5vNT2S85S9oONhtSKOZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GE1IXM2F; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GE1IXM2F"
X-Forwarded-Encrypted: i=1; AHgh+RqvvRdttmZvlwtCS3ehKG/7FScYqUwRBrS+Rqn6cw+j68pZTHBndd0/OKBQdLfOLdAw4oauYmQ=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784576723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gnRgW07hzLRCxIKekWyNR2ruwTjgHHkQMx96GO7mN0k=;
	b=GE1IXM2FFsUbMgD3tbSp12QPGPa+ZTt52q4TPHh4H3KkMFPV5L8TA9KFdHv+Lkc1cbnpcx
	r0lAeqcAhQnUBN3sgTM9IxL+1FDHMQWYqtrATBG7UFXh6nRIv5AabWgX8WIsNBcsHxZE7q
	ieGbRLCODet233WM9APisoWijzoC4YA=
X-Gm-Message-State: AOJu0YxYzcA6ppGqBWoCC1Ys01w8Mp2AYj6vzuqqLo9cy/TC78zUP62a
	zuPVdOgYdBTknJcWbns+uez7n73wIwpBUsxPr8qGy+kq+eAGzAJoN8fCRG83I7PvVONOySLVQf3
	Yx68AbQ3qNcUTI4+JXJJ/5UJiz37Ts3yCNszdaTyi
X-Received: by 2002:a05:622a:d0e:b0:51c:ca9:3d17 with SMTP id
 d75a77b69052e-52601f03537mr5544981cf.12.1784576711189; Mon, 20 Jul 2026
 12:45:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260715105100.3178255-1-vdonnefort@google.com>
In-Reply-To: <20260715105100.3178255-1-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 20 Jul 2026 20:45:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyVRn8BR7bLBo5m_k9m1VNv95y4h+WTJvz86FTf+=XeFg@mail.gmail.com>
X-Gm-Features: AUfX_myO2U0cPSk1RjmpSUdu0_huarr-ty_DjO0s1lnxhyEnNkUc3-HgW4xg-JY
Message-ID: <CA+EHjTyVRn8BR7bLBo5m_k9m1VNv95y4h+WTJvz86FTf+=XeFg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Fix hyp_trace clock disabling
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Vincent,

On Wed, 15 Jul 2026 at 11:51, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Fix the disable path in hyp_trace_clock_enable(), which fell through to
> re-initialize and reschedule the clock after cancelling the work. Return
> early instead.
>
> While at it, cleanup hyp_trace_clock::lock which is unused and
> hyp_trace_clock::running which is redundant: the trace_remote framework
> already serializes calls to the callback enable_tracing.

Although the cleanup and the fix are to the same commit, could this be
split into the fix and the lock/running cleanup as a separate patch?
Since b22888917fa41 is already in a released kernel, the fix will
likely go to stable, and it'd be nice to keep that backport to just
the behavioural change.

Cheers,
/fuad

>
> Fixes: b22888917fa4 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> ---
>
> v1 -> v2:
>   * Rollback hyp_trace_clock_enable() on __tracing_enable error (Sashiko)
>
> v1: https://lore.kernel.org/all/alczBmnItMwq8xj4@google.com/
>
> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 2411b4c32932..9bfa368dd841 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -37,8 +37,6 @@ static struct hyp_trace_clock {
>         u32                     shift;
>         struct delayed_work     work;
>         struct completion       ready;
> -       struct mutex            lock;
> -       bool                    running;
>  } hyp_clock;
>
>  static void __hyp_clock_work(struct work_struct *work)
> @@ -110,12 +108,9 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
>  {
>         struct system_time_snapshot snap;
>
> -       if (hyp_clock->running == enable)
> -               return;
> -
>         if (!enable) {
>                 cancel_delayed_work_sync(&hyp_clock->work);
> -               hyp_clock->running = false;
> +               return;
>         }
>
>         ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);
> @@ -128,7 +123,6 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
>         INIT_DELAYED_WORK(&hyp_clock->work, __hyp_clock_work);
>         schedule_delayed_work(&hyp_clock->work, msecs_to_jiffies(CLOCK_INIT_MS));
>         wait_for_completion(&hyp_clock->ready);
> -       hyp_clock->running = true;
>  }
>
>  /* Access to this struct within the trace_remote_callbacks are protected by the trace_remote lock */
> @@ -304,9 +298,15 @@ static void hyp_trace_unload(struct trace_buffer_desc *desc, void *priv)
>
>  static int hyp_trace_enable_tracing(bool enable, void *priv)
>  {
> +       int ret;
> +
>         hyp_trace_clock_enable(&hyp_clock, enable);
>
> -       return kvm_call_hyp_nvhe(__tracing_enable, enable);
> +       ret = kvm_call_hyp_nvhe(__tracing_enable, enable);
> +       if (ret)
> +               hyp_trace_clock_enable(&hyp_clock, !enable);
> +
> +       return ret;
>  }
>
>  static int hyp_trace_swap_reader_page(unsigned int cpu, void *priv)
>
> base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
> --
> 2.55.0.141.g00534a21ce-goog
>
