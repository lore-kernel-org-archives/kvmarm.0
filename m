Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38A129C347
	for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 18:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762887286; cv=none; b=aYJHgxUTANfknIGI6B6EitjaBV2ZCUmkH4eF5rr/zIExgXSL/deFdQzaAg9ws/QnR//g319p8OpKiK9UhIzcNB5pnqSzVJUmF5GCIGeOARsR6pEILalLNmge2SPTZN5oLqLBTbK6NY+I6hqRFFTPVhaXdg9RIKi36S4yp37V0V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762887286; c=relaxed/simple;
	bh=gNjTFrNkSvtB3DchgmaRfnaI4p/1hKhkmvofjmSh3bI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AsGGdjqhxwh4n0CVsWkEzGiYFnghDLJgwHuq43MxdvzEuTdXCca7el2Jpj0OxavKPsXXt535ATVmMY+kVWhrG7URT2njesXTktSleg976QxEwrLaGc3SJU83pYxrYksCW2/oMgWW1Bsm1ESt5OmHxpq8cnW1ziNSaMzPmaoWi6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iWbtrcLD; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iWbtrcLD"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42b47f662a0so365605f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 10:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762887283; x=1763492083; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PdRUynOgPlBXPJo6ql5MWyX9Riir7hsBESxiC86Kk1c=;
        b=iWbtrcLDuAPYW46ZLjthILIx2iPB26j98loW/93AzuwNmFxdVrgMcd6KVo0sXd2cQ5
         47SB32MIBwRcLbkFI0TlFRM3rC6Lzpc+xxwhCwKLN0Ij2WJM4zOUjIvrjFxYUKMN3Rwe
         vKHyiWB0KI3uSuyfTObjmBKN35vhfS2lC8ISZcgX/xeb+EgH3EEQKvYv1+y8U+BK04gk
         D+LIt0upYbOhSn/p/uS+mTTu01/i3xayPzdPPR+gMo40CAKOFmRETFbFFcwNwc0NrATM
         IrbFT7rG7TNUbVg9GBFRzc4sbgPQB4l1++x8Kmy8A3/zO12eR9esjHx6mHs5M/98TUq2
         WgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762887283; x=1763492083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PdRUynOgPlBXPJo6ql5MWyX9Riir7hsBESxiC86Kk1c=;
        b=VWRckYZ7dWv25KCH0DerYoz3kTONez6+C+puW9pHLkajpS7v5qxl0E1UEsCLTQ4EzM
         +A6hpKuvBucG9EpbtIGOagdP41mBGbWf5gA6vdbDYzRwfiSgsfZWfLzjt2KDu84O0uw/
         GxkIgvS2KsdxFLNxcD1xjFHUmj1jmz7+GksXM+lO8whpYkJcYNaxuBkGR/7PI+D7S+oS
         PryAQnSN46fojk5F34V/J4QPnnJvRkndiSXqp62g4h7Xvn7tro7HctksdFrI8Zai18+J
         bTgyUWoOot2Htdbi51vWV4/IPfEb86ZX9oK6+TI5eGrPxLiTbZjz8jJetwOoFV9DXF9d
         dAMA==
X-Forwarded-Encrypted: i=1; AJvYcCUPzOm4q2jYzn+SmTu74NxG8WhOUyn6kSyEzLYSNIYs7F11eEJc3B5A8exOyle7Fv+o0FwRBGc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJV4VAEedZvCdhRe/pMhP5bEN44xmnzGH4xVYitTN8pDKJSlwK
	6wBicuoqvQILyBXEfEg1v1W5KgiwU62+thI+1U2KkFf8KNBbNPJoWsQT
X-Gm-Gg: ASbGncsh/x/9UBITOJFrtdXvGGWBoXwadAYKNFcCKBTn13T506jn/tN+7RJvQIHp1ms
	PIivjRqU2FJQtHQWIR0t5swTU275eRF9oCTw5jlBxQXL2S2DZO4Duefwt120yNejIMd3y5ypte5
	JR5sI91+5jDT392BcoRtMhXt461isjVApsc4hSccF6CPR7lgGmjExsjKOqEb47QjR+LAZBzbDlL
	zEp+23ySbIGXgqkxwsqTWlKbFKFdcJU/WL1H3wNWvvr1axBeGmhqjSv3n+QivONP7fxp4cDYK4d
	XL6N+EygFM6ww5TS08lqipvH8rDLju8aJtSa9hDIuZvDpQRS29gqqfz7jeR4pkLtdgjjLU5zugB
	83rH+Rj3roq2hyGd0laAebXUfNvMnfbntlXMDrbJcX8o/yxfIH1cQLNC8J1by3JylEEtIeFUTfe
	GIqdqmxcXGzg==
X-Google-Smtp-Source: AGHT+IGd0fmmG6z7kuRrMZdV6g6rc2EMUpgF61dCExt4OzGkFObjrnlzVeQMOCeTSTsuKBksjsQQTg==
X-Received: by 2002:adf:a41b:0:b0:42b:47ef:1d59 with SMTP id ffacd0b85a97d-42b47ef221bmr2063764f8f.4.1762887282987;
        Tue, 11 Nov 2025 10:54:42 -0800 (PST)
Received: from osama ([197.46.148.47])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4776bcd51dfsm271008845e9.5.2025.11.11.10.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 10:54:42 -0800 (PST)
Date: Tue, 11 Nov 2025 20:54:39 +0200
From: Osama Abdelkader <osama.abdelkader@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: add missing newline to sysreg init log
Message-ID: <aROGOivTetFI01S_@osama>
References: <20251110211051.814728-1-osama.abdelkader@gmail.com>
 <86346kvr00.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86346kvr00.wl-maz@kernel.org>

On Tue, Nov 11, 2025 at 09:49:03AM +0000, Marc Zyngier wrote:
> On Mon, 10 Nov 2025 21:10:51 +0000,
> Osama Abdelkader <osama.abdelkader@gmail.com> wrote:
> > 
> > missing newline so the  message is merged with follow-on logs
> > the change only affects console output formatting, no behavioral impact.
> > 
> > Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
> > ---
> >  arch/arm64/kvm/arm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 870953b4a8a7..156cd1a6106e 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2845,7 +2845,7 @@ static __init int kvm_arm_init(void)
> >  
> >  	err = kvm_sys_reg_table_init();
> >  	if (err) {
> > -		kvm_info("Error initializing system register tables");
> > +		kvm_info("Error initializing system register tables\n");
> >  		return err;
> >  	}
> >  
> 
> Given that everything in kvm_sys_reg_table_init() already screams
> badly when it fails, I don't see the point of an additional message,
> and I'd rather remove it.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Thanks Marc. I just sent the patch to drop that message.

Thank you,
Osama
