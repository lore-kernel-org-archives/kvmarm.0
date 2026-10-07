Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC81472091
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 11:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791371286; cv=pass; b=T19qnAGTo/qyB8j+eacN0ULqnR53MXpp6VkZWiUsxg4TgiajKFrJSFtxJvM5BMUfahTjTdNHc2RmZ+Zte0pzCl61+2XTtzixl3NTditglwE5ALeCoTZWUMvdR3ShhFo/EeV+w8zw9OOA00UaGW3XENH0PSppdd1oTK2OWBCvqR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791371286; c=relaxed/simple;
	bh=n6pA0UCaHovGcyxtuarmqmXJupW57jUc87NPA1SduJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zd0JPAOax4MwDW1eFdyuQHyhM31fgirS6LkWT5KFtyQ84XnJylXl0nOOtJJ5Jv8cofvsep37W8q6wLRZopwBpZcTSdaWr4vOdQpcekYb0ot5lG0gPFVXTcLygIvS7TZ7hf2lyb7jc4lt8Y91NtZy5Yl38dJGIfpkRRksnjWhnkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NWh7pia6; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NWh7pia6"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5bcc04c71f5so7553e87.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Oct 2026 04:07:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791371259; cv=none;
        d=google.com; s=arc-20260327;
        b=G/HbYlgjKqh09Uijg4EbGyvr3yqkF/IenS4sifBxOs93T7TqX3zgGX0xV9P0/1e359
         2vwhBmBwLtHxIBo6Ab8cIbf/6CR3A34dnbWMLWUssMDQb3yZyM4XdHQ7jWZXaIA0VFw5
         CMBdrQ8+Lc2+/hylPl0+1JJI1YIW2Mq99l2U9PZUVAO4qveGPHce1KKe6mqALW0swEuc
         s4TMnZj5wUjGgPBE0sRjjAopQZQgj6+Y9zXEQuXMzYj5PMQgLuU1P7cDveIbJZDJDymF
         aYxe29NAh8BNzcM5DXztiKaU5pfU2RWbr1j5RjASf54Xy/aM0DfFD2SLxDtWPqrsw8YV
         QuGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=n6pA0UCaHovGcyxtuarmqmXJupW57jUc87NPA1SduJA=;
        fh=ivij8suZ7KEoGoPcUjiwG8ZJ83Zct/U6LKycmGJQCl8=;
        b=TSEdwn0dTX/RF+zA+mTqI1JRDmy7Yo0BEw5Wsq9QiT3EPpzf2b5TUAeP+TSsOWaLxz
         mclaL23T+21et2Q+hz6yAOOkIRR+lWnu8qknqLjSrb/K5fu5BPdLK/JoGhVbYfBiW/M+
         CwBLuXpg0qzs5S4r+kTCOGpFVmLQPjoAU2HJN9EFural18n7kFKQ2Oy7RtXPXSsZPG2C
         TjqVej0NH2eBXVedi0VWujgzQUfHdVF2LUPuTaJp3ZyB8dlCfsaDwIBRlLgwLgR9w/+G
         7+YdvHC9D/6/p0RdrAm/FY4OPahB5ulcIOR4I0bWKi1LcjKzL+iA5e+v0IBDZb22vD6F
         fpFw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791371259; x=1791976059; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n6pA0UCaHovGcyxtuarmqmXJupW57jUc87NPA1SduJA=;
        b=NWh7pia6v7nzNbWS2VW1qeMH8+xKwDt6aNt2mFk2sH6dy9vZQCIwMOx5++lAjz/Kqg
         E4+1Uo+V7qrdt1R7CSp8aRHlNAgY1UCLPojjT327TKhIQwLgPoOM0aW4mwJ2c9+G2Bw9
         5FCwDHygxWNdWapaCF+1LkyUx0JR1Oy4Blzj4p+EgHJbwdWhqyr/rHTpdvcFzF0GLrAR
         85np19eDSl/t7i0zCsJAbizVJh9Gp29du3zdBMcceiz3kKKILEInVr5LoCep9Qhh3/kg
         64bhNok3EaAWBHwxuIWKfzqAWMwQ/anoK25tUvfupAs2zD46DrWaIgrlGAdg1KrdjcTh
         /beA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791371259; x=1791976059;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n6pA0UCaHovGcyxtuarmqmXJupW57jUc87NPA1SduJA=;
        b=Bhy3fS5Gi0mBFD68KmnUQVkpFHakzSiX7wdLeF/QUsX06XDVfR/w5YyXjwvLePqR0j
         jLmAQuciDE67WlT6YlPXgD36aqdQ1+UZZ8cRhFNyydB9LdGQLSP1icWjSTRAtZSTi+5N
         99N+PUbjP6ed8+9VXUwm+lT6OBhI0ToRBjpefqQeicys+u5izVdD8BFd/EGJCTsDZlZN
         hUuLRCPFVTde8nS3dmB5ukZKop5xQwk1TibtDoys0YHuaIxdL+TQFsh1xuU0CfcgeG8Y
         qnD/yGK+yOQcvan5+thQihCmfNGeWLMRpQw8d0woyhjNwfZnNKI0a7M6taR55WA78ZaA
         L8zg==
X-Forwarded-Encrypted: i=1; AKwUvByqsbcR0vdIU2mnZ3Gh8wkeFski0gYEAwGhrdRIShgZnCXcwaatHjCls5Dm0FA6GK09ScqkUkU=@lists.linux.dev
X-Gm-Message-State: AFq9FYITpxx6VrOx1Kh/2CO3p328Pr/I0UXwP0oN+jARStNMZQCm+bVm
	7oJpfP9YbnVaGN32hbQoyx/cuttA00mfPkZQ8ZspKedS1xNsoEA5g3MYH/XigIl+UkEmZs1Ecxo
	HxO+UVr21gGZZX1/qs3dHEogKtZqxj/UtZjzKil9x
X-Gm-Gg: AYBFou0j8hHUDEARPq+jdt6FQwZs+3qMjOqp7MvFzjKdMWx4ANVFVEEuKvNc0ePij/9
	oF+Togm6zLyxOfStwNbfC/OJl+7YwNc/jxVEz2g0TMPIWfZBBOADz8Wheg6urhgO1J2mdzHFYmm
	J0uj5ioO2eHBCyMwpP+ugVcyqhYtpNX77HjrtFy9iNMHPs9Xb16QDF8qpQkvn7TUVW/MuY2iVs3
	PCrnMFB0QUXyfThpKu3kJML5PlrlJyPkbJvTt02YX7lQgI9os43jJBhcFHss0STs70vySGaL0uR
	TauIgsT0R8d9Y4SB4tWg+LDgnE7XPAT+cs9LLMLCUjDsqhr+qJtU5zg=
X-Received: by 2002:a05:6512:1189:b0:5ba:3534:fb8f with SMTP id
 2adb3069b0e04-5bcca674bb8mr331538e87.15.1791371258668; Wed, 07 Oct 2026
 04:07:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com> <20261007073537.2454351-7-suzuki.poulose@arm.com>
In-Reply-To: <20261007073537.2454351-7-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Oct 2026 13:07:01 +0200
X-Gm-Features: AclHuK_51tZ4nsMn3i-NEL4Otzbz7dcWMCHjhG-tWBC19X6nKIZVcoWjuDrLVic
Message-ID: <CA+EHjTw=9e4xv8SmUggCgHBM+uQ2v7dWSOf9PeBufMUofYPMwQ@mail.gmail.com>
Subject: Re: [PATCH v23 06/14] KVM: arm64: Don't call vcpu_set_pauth_traps for
 pKVM host
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Oct 2026 at 09:36, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> vcpu_set_pauth_traps() bails out and does nothing for pKVM hosts.
> Clean this up by moving the is_protected_kvm_enabled() check to the
> caller, in preparation for adding VM specific vcpu load/put callbacks.
>
> While at it, do an early return if the vcpu doesn't have ptrauth.
>
> No functional changes
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
