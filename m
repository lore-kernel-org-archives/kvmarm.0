Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63142396D1A
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 14:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781448448; cv=pass; b=XY2QT8giATu+yp4oJAjq+xYa3pUwpoCp41+Tc+M4LFlkoOKT6vfzwTXPLyQTlWr3Iprv1zfTe0/jAal4GJw+AfaASmxkpZHFP+zzEw7n1hORGrkkAbHu18m4to9Hh4khObV1MOpM1BHn4yADxzvrLRuOHhwq2Pz4q2C9JPcNo3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781448448; c=relaxed/simple;
	bh=0/yNZii18BSyP6ygxi9jiQnDLOS1HXiwOjH2zfnTn2o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u3ZTf+UOihA/n8oPlJr3XsGXCTkdnU41TVLLQw5QI6T2OjUnTW4t/YS4YmSqcDYQ4o72cgXG0GJa1pnDbLivh0cTxPsM+Zsg/mj3iNgBHGDg1vrHIuzsxHeZzyQyNZ5v7EGOr9i/9J1OPd0mSIy0d7LfJfWnjQgdi7VDo/AGJqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=reOdIXmN; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="reOdIXmN"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5177d1ff061so533281cf.1
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 07:47:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781448445; cv=none;
        d=google.com; s=arc-20240605;
        b=QbQvqg6oFePtF5ZkrJnIHPWSLXcWzlbEvfpL3Ek96Zl1J83O4j3C6Md9qC/xglmOD0
         nILOFKvKmLtEiuP3i5rolxHyuEZvD/uR/H5EKW9WLNRoayvp0ebYXoNwUDttsfQhPXkB
         sgKRU7X0cH9g7i5Hfd0CEflM1Qd0lCE+wymqJAdzTVYpu0Yxajg45ss39U8vRrGxeNWY
         zaWaodVXGTsxM2n1TcaZMKqpvC9twAvBwaC74QREwrtZg32NBmtCC5g76msSU4qQMgy3
         5Aq6SuwIw/uyfiAkgKVuMAkxaNi5FIwfoHXBXz04oSALx8KcmGIFI98NhZPS8gEumMzO
         6V6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ESC+v0XgmstDdpSeKPKLi7hpKQuqlzaVaJSl8UIzksU=;
        fh=4o/vRRaiNXSHuhhewJAZ2allrsyRbg9nVG77mvW8nxU=;
        b=HVHIYevJ9JJoc/qfxR6DpXbn42nJExODwP3TDqA33oZD589y1J1v2pfDeu6HOLxh/U
         HKpqy1lwRizPZ9wNu6dTCCw8sEvh2aRH/+2sBQCcoMT/vEQMiIt8bfWvjPBYqQW1JrsN
         SyZ2rV/4OvpqazVC5Ygc2vF9nJvxAs2gcLd2cLXV5v281czsok52Jx68JSMTygHdaV7/
         Q5VANuna5sCZ7fc3NtX9wygJ8Jbr2eI4oaM5J+mXLhb5VHVEerFLuCzwWOUQn4pNi8Ed
         Uzw6coc+VoUHfbt+9JL95NHGdSwaZcj8pKKeQjCLNlvTpIyPhl79rvi0hOJAwx3EIjg8
         dsIQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781448445; x=1782053245; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ESC+v0XgmstDdpSeKPKLi7hpKQuqlzaVaJSl8UIzksU=;
        b=reOdIXmNqAnxLZd9Z86pmMgrvALem9q5JtTfpQFz9JepORDwVoy2tJgaQH9CBAq5yZ
         rz5Jl/WuLZAWBbwWDMoXTyXdwWIMVOwOXViItelIPTFrj3J0G5JGqYS2dLA6qqC+Uw9M
         TndJ4vZvBR+Klrqj4dwOokhA32G+r0Vr48eqp0q3mtNU+FbOf8pXgdrBTWe7PTeWs9UB
         tw+I2AuoaJVw0YhfHQpbg5ejL6/t3SxiOoJIcHF/YIvh6Ah2u42buZsg0Fokl7A4Cd2v
         ++ZNXQUugpPsf5MhwDiasg0SDQJa/Flek/w06vG10G0kX4KN49aVPwDQ3Tl7WURcZwRa
         BCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781448445; x=1782053245;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ESC+v0XgmstDdpSeKPKLi7hpKQuqlzaVaJSl8UIzksU=;
        b=Rof4rr0Ib3T94UUoWO5w3Rr0jnpQqACVIGVW2QnCRtbqSFD7vUi53hdGpKNArh2DRO
         XpYPcCtjVIS2oLYUfEM3Dq//tgTBZiO77OGn+ANVmxNRqEwHlLfmkZURnvZz/nxO8/9w
         XX8yDj1nw2o6FY5Z/1YUyn3yUGeICgzFiJhrsNzqEgSC4I/y/nvPNrGEiPHBizwQjKIf
         OkBv9W5cLEGnEPidPjsYYjirLt+EkyJTOQDy5TAIE/EbbV33KDRUibpGWHc+AyBwYIZc
         lNfGfTQdYa6lgYjzPInLCA3NkDm+oTzQJBZ4TRpyQYkvo4+D5IFp+Rq1stetM2BtzmR5
         eoRA==
X-Forwarded-Encrypted: i=1; AFNElJ84tFQ8sLUbN7j0E8AtN8Lvr08Xv4tbvbbUWNOlRqTCGrLe6my3msPIXvdFOznMukDIDrao3i0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1mNDudPnB6cYcjMqKDvb8SdhTYhRMA30C+S0czVORFo0gXZaI
	L8cnZcFgBudcaY60oyONw/Pdri81lFVZSbBkgBOBrvMs4u+LZjz6UXAo6zjDX7ps6O57dKVKtQX
	zZv0K09UDK4wKhvgGMB0cldsO9K6SMUkaG7MMOn4e
X-Gm-Gg: Acq92OGXBk8x2hy0MFrSQGg9G3Hb/PqB2Rdf5eq91DgCHoTlNdhmVbjBZBiB+OEu5AL
	Gq4QTxFJJESPO2YdNSHVlmiVA84rA3hB9mnw6GgUPjGUaTfdoNcAH2jySTXD0cJNQ7BVg1dBpgH
	Q9oNTbUto7bGCkjrlerSueoNHWhRpL0ksq1J4adYwzq9w0uAUzvAPh2BQH1QN8cdpIav2Hxcc16
	1GZPQcbQmtNxzXwmdtvTF+snXHiYcLfMBoyd8tejQjjZci+3iyfnVk4wVxoZkFgRNQ1OmHd1LTF
	1NWhcF0CmcFZ/ojH1ok=
X-Received: by 2002:a05:622a:130b:b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-51955e96830mr10838431cf.7.1781448444601; Sun, 14 Jun 2026
 07:47:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612142245.1015744-1-vdonnefort@google.com> <20260612142245.1015744-4-vdonnefort@google.com>
In-Reply-To: <20260612142245.1015744-4-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 14 Jun 2026 15:46:00 +0100
X-Gm-Features: AVVi8CdPI9qwkxm2EQu_Iwcwk_7iZT6Mq7CK1wTAMeM5gn94DrPfRYjAc8Hfnus
Message-ID: <CA+EHjTz6S342aNXxj+yNvS1mLjm0r2fUW681a1jNo2+70rGVMQ@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kernel-team@android.com, qerret@google.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 12 Jun 2026 at 15:22, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> The current REMOTE_EVENT() takes as a __printk argument a string format
> and a list of arguments, such as RE_STRUCT("foo=%d bar=%d", foo, bar).
> Add a REMOTE_EVENT_CUSTOM_PRINTK() where the __printk argument can be a
> function. This intends to support the creation of a "printk" event for
> the arm64 nVHE/pKVM hypervisor with a dynamic prototype and by extension
> a dynamic print format.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> diff --git a/include/trace/define_remote_events.h b/include/trace/define_remote_events.h
> index 676e803dc144..4f4d58e37b84 100644
> --- a/include/trace/define_remote_events.h
> +++ b/include/trace/define_remote_events.h
> @@ -35,17 +35,26 @@ do {                                                                                        \
>
>  #define RE_PRINTK(__args...) __args
>
> -#define REMOTE_EVENT(__name, __id, __struct, __printk)                                 \
> -       REMOTE_EVENT_FORMAT(__name, __struct);                                          \
> +#define REMOTE_EVENT_PRINT_FUNC(__name, __printk)                                      \
>         static void remote_event_print_##__name(void *evt, struct trace_seq *seq)       \
>         {                                                                               \
>                 struct remote_event_format_##__name __maybe_unused *__entry = evt;      \
>                 trace_seq_puts(seq, #__name);                                           \
> -               remote_printk(__printk);                                                \
> +               __printk;                                                               \
>         }
> +
> +#define REMOTE_EVENT(__name, __id, __struct, __printk)                                 \
> +       REMOTE_EVENT_FORMAT(__name, __struct);                                          \
> +       REMOTE_EVENT_PRINT_FUNC(__name, remote_printk(__printk))
> +
> +#define REMOTE_EVENT_CUSTOM_PRINTK(__name, __id, __struct, __printk)                   \
> +       REMOTE_EVENT_FORMAT(__name, __struct);                                          \
> +       REMOTE_EVENT_PRINT_FUNC(__name, __printk)
> +
>  #include REMOTE_EVENT_INCLUDE(REMOTE_EVENT_INCLUDE_FILE)
>
>  #undef REMOTE_EVENT
> +#undef REMOTE_EVENT_CUSTOM_PRINTK
>  #undef RE_PRINTK
>  #undef re_field
>  #define re_field(__type, __field)                                                      \
> @@ -70,4 +79,8 @@ do {                                                                                  \
>                 .print_fmt      = remote_event_print_fmt_##__name,                      \
>                 .print          = remote_event_print_##__name,                          \
>         }
> +
> +#define REMOTE_EVENT_CUSTOM_PRINTK(__name, __id, __struct, __printk)                   \
> +       REMOTE_EVENT(__name, __id, RE_STRUCT(__struct), "Unknown")
> +
>  #include REMOTE_EVENT_INCLUDE(REMOTE_EVENT_INCLUDE_FILE)
> --
> 2.54.0.1136.gdb2ca164c4-goog
>
