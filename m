From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Re: [PATCH v5 13/22] KVM: arm64: vgic-its: Check the device id
 matches TYPER DEVBITS range
Date: Wed, 26 Apr 2017 16:59:52 +0530
Message-ID: <CACJhumfcvzq0U7TJzqQJtZ5=FWCbNXqDGZMRQgy4VZQtA2D0nQ@mail.gmail.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com> <1492164934-988-14-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-14-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 3:45 PM, Eric Auger <eric.auger@redhat.com> wrote:
> On MAPD we currently check the device id can be stored in the device table.
> Let's first check it can be encoded within the range defined by TYPER
> DEVBITS.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Prakash, Brahmajyosyula <Brahmajyosyula.Prakash@cavium.com>
