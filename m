Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5640128816
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 12:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779193834; cv=pass; b=LdMbNIsT7O0HT1rcgpNRX7ibD1mJ30wsenwHceyZZLwfwiMTZTXaLVZF7lIiGv5EN8vPzS3DBu+MsPbRiut1XLky3xUWClq+kl9DUxNvsRaHbm7x3o/KYkxjs6Vgsfm7mB+n+PvH7nauVy9Fg7cBOQwteLo263jz8XtKs4mjqvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779193834; c=relaxed/simple;
	bh=CsQncO5E+h1CWjDswq6lrwGwTFBxqyNEZA+Zb+AgVB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=neOPwzE5X07O4hfX2wnxW1YY+JNgNMiQT6TmktyxAoEHmEkRckfAjVPQTmlGy7Z6ijDtSVMOnxjNncT50xTVF6RV9YVqFp7MLpY7SJ5RKkohPJ+wVU9aUoSsmsKPrzg0QxJ9WC/htg+wI8XpoU40b4w/WtTizge4rjd1ep+Wxb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F1TMPYDH; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F1TMPYDH"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-515548f390fso61cf.0
        for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 05:30:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779193832; cv=none;
        d=google.com; s=arc-20240605;
        b=hSBHD/ka1sgM2dIqWQUjyle41+exCToiZzYOcYpKljPjUIMo4QMTlzYQAqGEOUSBv7
         u+DuSnovdfpOforHa8m+++Nk3JZOSH0TcGYn4OpWMP2hoS62PeD4YHRgQXpk5FgtNgCP
         Mr2tk7rj2MQijTx1i+2mSoFLhVJmiq2gTbV2WghYgOOQH9fMzYKthtg9vjwuWRNoN6aA
         Z19zwCJyC4wDzbiclnm6meZVNGfZ+wTS5Dmyu2Slwcs/gqhCouOrUEFyvdC4cp9QALW0
         edc6m53ihOxMOkr1tm5C4XBd2IiWyTJjKwJvPpKkLrU/S3M8GVBqtXvLAy/jx0REFHGq
         7sHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=T4sIM5W7sb+vgXCeGk89INhm5L5HYFz3xkdbbX+NpWs=;
        fh=SFZGMLwz3OZXLp2xckPIyRljw6dzXjMpESTir5naOsA=;
        b=P0GLCIBkX53RYgaMHC2Eic/KGm2bYfQ4eC8wbWACL0SiWKQplbm0yhA7G4wCe3/0eG
         +HylKp5SJHfA253My/Axtj8hD/jdniBVBm2g/YC8LN1OrG2S8y0xsyCXZ8BprKOt8HeE
         bQq15CMzCFxSVmN4tTw88+GPTjyC0TvJiuBMwC103zB3j+lq+RSkpFxfbgjOlRYURjBX
         KTqRbeU5qSYflujiNFvOhqvcdCQa8m0/HYvkkdVy7NkqGRFDwe+i0YdI8m6KT31jSFaf
         BE+spOnZjEneeBe0AkQ34pmxiJD1+XOwkIYx/jaBjLCQJU5rWbCEZIgw/CYxNhRh+ABA
         +UDQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779193832; x=1779798632; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T4sIM5W7sb+vgXCeGk89INhm5L5HYFz3xkdbbX+NpWs=;
        b=F1TMPYDHZFfIQrD62ygtBBJB8gdyLn3neXZZn5bBWuiyqwHsRRoPkHXchjZkcstbgP
         z0AmCoJDK8VqlhSBjfhCF0+Mta43o8hhAeLgIfYJsQ7vfRciuKkzEB55MjUVpHmMhlpr
         rsOrd8QVDS6NXEoIV97iignsMKUHV0T20u/kToNoj//uErFqrzNd1BetfUfMNv1DMTYQ
         2uheswGUxbDH3x5Go9CXEKDx+LksYfpPtVulRPTHtPkqkJXozX0Y15hKcSVj/mMoB0hi
         jAbV9I+nABFbebFvgEAD2s200W0Nzv8545ovgQqwP9Wcion0SVe2scJhsszeJeKMpP5G
         ZzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779193832; x=1779798632;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4sIM5W7sb+vgXCeGk89INhm5L5HYFz3xkdbbX+NpWs=;
        b=cWLC1MCYpEnaG/7fjLo6TfbF4uJ336q/TBXKqPN/qcXY7s+fIN3VeiW+I8Ge84IMD0
         /A4LbMhUHxDdxqvMqkuAdx1vnX6jFCfseaHSV7KEt/aKnBy+xdNNB8c3qRq0PEmGvKFx
         tU8pSBW7sN5H6q4/ZTtxmW1mv40pc6+mM4nsUkIEL/KMurdkH5Qss542smPpv2dkpCcu
         SXphKBoH/3Y2B6yiQVSM6IUPOxdPp8zPTKQF8nfAT4suzTwEWWzMQb4TBsZqeD7vsO7N
         6hqwihqrb4Zq2fsV1pEbCfua9VgiUb+2dbxO8wBGEiBg9tdkUm8VjlXZmb3PQwXYxomP
         Zeuw==
X-Forwarded-Encrypted: i=1; AFNElJ8y9isg1q5zAsXa+jSPCg0f3K60QGPEBXBeIqjolveYbS7LskGF3O7YExtOcoD2KT6kCc93wEc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwB3F1sC2Omn9uzNKLPz1xfx1n0t5BDVlW6+5r2emlAu7jgoI/P
	YuVFThQdLkcwU/BZuDoOLXS4wTrJQN9/i84N2wPZHY2e3pb0YSWjYTWkbHBq2dgx2yA2wX2AEUw
	ESBUB/rzVBFKNCTpNjDZ1Z13CIgGCtw5dEz4ykxH8
X-Gm-Gg: Acq92OF1nTtEVk72DMlL9cEPk45gnREi15E0+cfL+Csn1/FPG5eItmUVlKDyzOZbOy6
	CK8UUgSL4wWlgRZhT8IAuU2a53xLfltqwh/plm5wd4foXHZdJ9zkp8wsnIbkRQGdR94Yhmm+Vj/
	8i+GiiNQfqj/KCFNXzsXC99i27vyLi/5sN9TXDMK0LTh6J2yiWay+JqoawZf7oEaOOjc+scQYnw
	naI92lcsYhoIt/htYlgdlxWnjNgfC6LAc6CQDkDsxvCN6yPBM/BkYzBEcGB8MAxtLZ5i6zvPqiB
	2JShJWQbZCZLP0SDfXoCW9Ptf8Ef5H/E7OnlnAEKpSJS3ZYE
X-Received: by 2002:a05:622a:258c:b0:516:4f62:85ef with SMTP id
 d75a77b69052e-516794623e8mr5463001cf.20.1779193830947; Tue, 19 May 2026
 05:30:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260501-host-direct-messages-v6-0-3f4af727ed85@google.com> <20260501-host-direct-messages-v6-1-3f4af727ed85@google.com>
In-Reply-To: <20260501-host-direct-messages-v6-1-3f4af727ed85@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 19 May 2026 13:29:53 +0100
X-Gm-Features: AVHnY4JCKN8u315XEm5-PkCtuH_gksQn8y22bEYloMMa3Htlz66vFU5m6nvVvsQ
Message-ID: <CA+EHjTyvc=cmx9pv34govtbxJ1TDd6RPDoCfMR-dxO-R1jzNMQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in
 host handler
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Armelle Laine <armellel@google.com>, 
	Sebastien Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Per and Seb,

On Fri, 1 May 2026 at 06:34, Per Larsen via B4 Relay
<devnull+perlarsen.google.com@kernel.org> wrote:
>
> From: Sebastian Ene <sebastianene@google.com>
>
> Allow direct messages to be forwarded from the host. The host should
> not be sending framework messages so they are filtered out.
>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 26 ++++++++++++++++++++++++++
>  include/linux/arm_ffa.h       |  2 ++
>  2 files changed, 28 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178..3a58e01d255f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -862,6 +862,28 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>         hyp_spin_unlock(&host_buffers.lock);
>  }
>
> +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
> +                             struct kvm_cpu_context *ctxt)
> +{
> +       DECLARE_REG(u32, endp, ctxt, 1);
> +       DECLARE_REG(u32, flags, ctxt, 2);
> +
> +       struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
> +
> +       if (FIELD_GET(FFA_SRC_ENDPOINT_MASK, endp) != HOST_FFA_ID) {
> +               ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
> +               return;
> +       }
> +
> +       /* filter out framework messages and validate SBZ/MBZ bits */
> +       if (flags) {
> +               ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
> +               return;
> +       }
> +
> +       arm_smccc_1_2_smc(args, res);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>         struct arm_smccc_1_2_regs res;
> @@ -920,6 +942,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>         case FFA_PARTITION_INFO_GET:
>                 do_ffa_part_get(&res, host_ctxt);
>                 goto out_handled;
> +       case FFA_MSG_SEND_DIRECT_REQ:
> +       case FFA_FN64_MSG_SEND_DIRECT_REQ:
> +               do_ffa_direct_msg(&res, host_ctxt);
> +               goto out_handled;
>         }

The commit message says the host should not be sending framework
messages, so they're filtered out. That filter is only installed for
REQ. The RESP side is asymmetric: FFA_MSG_SEND_DIRECT_RESP is in the
reject list, but FFA_FN64_MSG_SEND_DIRECT_RESP isn't. Should you add
that too?

Sashiko [1] also flagged two issues here. Took a quick look and the
tracing one seems to be worth a closer look. The upper-bits question
is judgement but plausible.

[1] https://sashiko.dev/#/patchset/20260501-host-direct-messages-v6-0-3f4af727ed85%40google.com

Cheers,
/fuad

>
>         if (ffa_call_supported(func_id))
> diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> index 81e603839c4a..f47d4bd51b2d 100644
> --- a/include/linux/arm_ffa.h
> +++ b/include/linux/arm_ffa.h
> @@ -269,6 +269,8 @@ bool ffa_partition_check_property(struct ffa_device *dev, u32 property)
>         (ffa_partition_check_property(dev, FFA_PARTITION_DIRECT_REQ2_RECV) && \
>          !dev->mode_32bit)
>
> +#define FFA_SRC_ENDPOINT_MASK  GENMASK(31, 16)
> +
>  /* For use with FFA_MSG_SEND_DIRECT_{REQ,RESP} which pass data via registers */
>  struct ffa_send_direct_data {
>         unsigned long data0; /* w3/x3 */
>
> --
> 2.54.0.545.g6539524ca2-goog
>
>
>
